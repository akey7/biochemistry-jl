using Catalyst
using CairoMakie
using DifferentialEquations
using ModelingToolkit

@info "Making reaction network, parameters, and initial conditions..."

rn = @reaction_network ex_4_4 begin
    @species begin
        x1(t)
        x2(t)
        x3(t)
        x4(t)
    end
    @parameters begin
        k1_f
        k2_f
        k3_f
        k1_r
        k3_r
    end
    (k1_f, k1_r), x1 <--> x2
    k2_f, x2 --> x3
    (k3_f, k3_r), x3 <--> x4
end

println("Reactions:")
for rx in reactions(rn)
    println(rx)
end

println("ODEs:")
@named osys = convert(ODESystem, rn)
for eq in equations(osys)
    println(eq.rhs)
end

println("Jacobian:")
simple = structural_simplify(osys)
J = calculate_jacobian(simple)
display(J)

params = [
    :k1_f => 1.0,
    :k2_f => 1.0,
    :k3_f => 1.0,
    :k1_r => 1.0,
    :k3_r => 1.0,
]
println("Params ", params)
u0 = [:x1 => 1.0, :x2 => 0.0, :x3 => 0.0, :x4 => 0.0]
println("u0 ", u0)
tspan = (0, 10)
println("tspan ", tspan)

@info "Making ODEProblem..."
prob = ODEProblem(rn, u0, tspan, params)
@info "Solving ODEs..."
sol = solve(prob, Rodas5P(); reltol = 1.0e-8, abstol = 1.0e-10, maxiters = 1_000_000)

@info "Plotting..."
sps = [:x1, :x2, :x3, :x4]
size = (900, 600)
fig = Figure(; size = size)
ax = Axis(
    fig[1, 1];
    xlabel = "Time",
    # xscale = log10,
    ylabel = "Concentration",
    title = "Results",
)
for sp in sps
    lines!(ax, sol.t, sol[sp, :]; label = string(sp), linewidth = 2)
end
axislegend(ax; position = :rb, framevisible = false)
fig_filename = joinpath("sb2", "plots", "ex_4_4_sol_conc_v1.png")
save(fig_filename, fig)
println("Wrote $fig_filename")
