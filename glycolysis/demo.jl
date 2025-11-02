###############################################################
#  Glycolysis kinetic model (Catalyst.jl + DifferentialEquations.jl)
#  Compatible with Catalyst v15.0.8 / ModelingToolkit v9.83.0
###############################################################

using Catalyst
using DifferentialEquations
using ModelingToolkit
using SteadyStateDiffEq
using Plots

# (Optional but convenient) bring common helpers into scope
using Catalyst: species, parameters, reactions, reactionrates

###############################################################
# 1. Define reaction network
###############################################################

@parameters k1 k2f k2r k3 k4f k4r k5f k5r k6f k6r k7 k9 k_atp_regen k_nadh_regen
@variables t
@species Glc(t) G6P(t) F6P(t) FBP(t) GAP(t) BPG(t) _3PG(t) PEP(t) Pyr(t)
@species ATP(t) ADP(t) Pi(t) NAD(t) NADH(t)

glycolysis = @reaction_network begin
    # Hexokinase (irreversible)
    k1, Glc + ATP --> G6P + ADP

    # Phosphoglucose isomerase (reversible)
    (k2f, k2r), G6P <--> F6P

    # Phosphofructokinase (irreversible)
    k3, F6P + ATP --> FBP + ADP

    # Aldolase/TPI lumped (reversible, 2 GAP from FBP)
    (k4f, k4r), FBP <--> 2GAP

    # GAPDH (reversible)
    (k5f, k5r), GAP + NAD + Pi <--> BPG + NADH

    # Phosphoglycerate kinase (reversible)
    (k6f, k6r), BPG + ADP <--> _3PG + ATP

    # Enolase (forward)
    k7, _3PG --> PEP

    # Pyruvate kinase (forward)
    k9, PEP + ADP --> Pyr + ATP

    # ATP regeneration (toy oxidative phosphorylation)
    k_atp_regen, ADP + Pi --> ATP

    # NADH reoxidation (toy LDH/ETC)
    k_nadh_regen, NADH --> NAD
end

###############################################################
# 2. Parameter values and initial conditions (toy units)
###############################################################

p = [
    k1 => 1.0e-1,
    k2f => 5.0e-2,
    k2r => 5.0e-2,
    k3 => 1.0e-1,
    k4f => 2.0e-1,
    k4r => 5.0e-2,
    k5f => 1.0e-1,
    k5r => 5.0e-2,
    k6f => 1.0e-1,
    k6r => 5.0e-2,
    k7 => 2.0e-2,
    k9 => 1.0e-1,
    k_atp_regen => 5.0e-2,
    k_nadh_regen => 5.0e-2,
]

u0 = [
    Glc => 5.0,
    G6P => 0.0,
    F6P => 0.0,
    FBP => 0.0,
    GAP => 0.0,
    BPG => 0.0,
    _3PG => 0.0,
    PEP => 0.0,
    Pyr => 0.0,
    ATP => 2.0,
    ADP => 0.5,
    Pi => 10.0,
    NAD => 0.5,
    NADH => 0.05,
]

tspan = (0.0, 500.0)

###############################################################
# 3. Solve the ODE system (stiff)
###############################################################

prob = ODEProblem(glycolysis, u0, tspan, p)
sol = solve(prob, Rodas5(); reltol = 1e-8, abstol = 1e-10)

###############################################################
# 4. Plot results
###############################################################

plt1 = plot(
    sol,
    vars = [Glc, G6P, F6P, FBP, GAP, BPG, _3PG, PEP, Pyr],
    xlabel = "time (s)",
    ylabel = "concentration (mM)",
    legend = :right,
    lw = 2,
    title = "Glycolysis core intermediates",
)
display(plt1)

plt2 = plot(
    sol,
    vars = [ATP, ADP, Pi, NAD, NADH],
    xlabel = "time (s)",
    ylabel = "mM",
    legend = :right,
    lw = 2,
    title = "Energy and redox cofactors",
)
display(plt2)

###############################################################
# 5. Compute steady state (dynamic approach)
###############################################################

ssprob = SteadyStateProblem(prob)
sssol = solve(ssprob, DynamicSS(Tsit5()))
u_ss = Array(sssol)

sp = species(glycolysis)
println("\n--- Steady-state concentrations ---")
for (s, v) in zip(sp, u_ss)
    println(rpad(String(Symbol(s)), 8), ": ", round(v, digits = 6))
end

###############################################################
# 6. Reaction fluxes (rates) at final time
#    Uses reactionrates + build_function, both in-place & OOP
###############################################################

rr = reactionrates(glycolysis)
prm = parameters(glycolysis)

rf_inplace!, rf = ModelingToolkit.build_function(rr, sp, prm; expression = Val(false))
ratefun! = eval(rf_inplace!)
ratefun = eval(rf)

# Assemble state & parameter vectors in declared order
u_end = sol.u[end]
pdict = Dict(p)
pvec = [pdict[par] for par in prm]

# # Sanity checks
# @assert length(sp)  == length(u_end)
# @assert length(prm) == length(pvec)

# # --- Out-of-place (simple) ---
# r_end = ratefun(u_end, pvec)

# println("\n--- Reaction list & net rates at final time ---")
# for (i, rx) in enumerate(reactions(glycolysis))
#     println("[$(lpad(i,2))] ", rx, "   rate = ", round(r_end[i], digits=6))
# end
