using Catalyst
using CairoMakie
using DifferentialEquations

t = default_t()
@species begin
    x1(t)
    x2(t)
    x3(t)
    x4(t)
end
@parameters begin
    Keq_v1_f
    k_v1_f
    Keq_v1_r
    k_v1_r
    Keq_v2_f
    k_v2_f
    Keq_v2_r
    k_v2_r
    # Keq_v3_f is omitted
    k_v3_f
    # k_v3_r is omitted
end
rxs = [
    Reaction(k_v1_f*(x1 - x2/Keq_v1_f), [x1], [x2]),
    Reaction(k_v1_r*(x2 - x1/Keq_v1_r), [x2], [x1]),
    Reaction(k_v2_f*(x2 - x3/Keq_v2_f), [x2], [x3]),
    Reaction(k_v2_r*(x3 - x2/Keq_v2_r), [x3], [x2]),
    Reaction(k_v3_f * x3, [x3], [x4]),
]
@named rn = ReactionSystem(rxs, t)
rn = complete(rn)
println("Reactions:")
for rx in rxs
    println(rx)
end
println("ODEs:")
osys = convert(ODESystem, rn)
for eq in equations(osys)
    println(eq.rhs)
end
params = [
    Keq_v1_f => 1.0,
    k_v1_f => 1.0,
    Keq_v1_r => 1.0,
    k_v1_r => 1.0,
    Keq_v2_f => 1.0,
    k_v2_f => 0.01,
    Keq_v2_r => 1.0,
    k_v2_r => 0.01,
    # Keq_v3_f is omitted
    k_v3_f => 0.0001,
    # k_v3_r is omitted
]
println(params)
u0 = [x1 => 1.0, x2 => 0.0, x3 => 0.0, x4 => 0.0]
println(u0)
tspan = (1.0e-6, 1.0e6)
println(tspan)
@info "Making ODEProblem..."
prob = ODEProblem(rn, u0, tspan, params)
@info "Solving ODEs..."
sol = solve(prob, Rodas5P(); reltol = 1.0e-8, abstol = 1.0e-10)
sps = [x1, x2, x3, x4]
size = (900, 600)
fig = Figure(; size = size)
ax = Axis(
    fig[1, 1];
    xlabel = "Time",
    xscale = log10,
    ylabel = "Concentration",
    title = "Results",
)
for sp in sps
    lines!(ax, sol.t, sol[sp, :]; label = string(sp), linewidth = 2)
end
axislegend(ax; position = :rb, framevisible = false)
fig_filename = joinpath("sb2", "ch3_sol_conc.png")
save(fig_filename, fig)
println("Wrote $fig_filename")
