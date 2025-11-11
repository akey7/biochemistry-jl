using Catalyst
using CairoMakie
using DifferentialEquations

@info "Making reaction network, parameters, and initial conditions..."
rn = @reaction_network ex_4_2 begin
    @species begin
        x1(t)
        x2(t)
    end
    @parameters begin
        kf
        kr
    end
    kf*x1, x1 --> x2
    kr*x2, x2 --> x1
    @observables begin
        pool2 ~ x1 + x2
    end
end
for rx in reactions(rn)
    println(rx)
end
params = [
    :kf => 1
    :kr => 2
]
println(params)
u0 = [
    :x1 => 1
    :x2 => 0
]
println(u0)
tspan = (0, 2)
println(tspan)
@info "Making ODEProblem"
prob = ODEProblem(rn, u0, tspan, params)
@info "Solving ODEs"
sol = solve(prob, Rodas5P(); reltol = 1.0e-8, abstol = 1.0e-10)
species_and_observables = [:x1, :x2, :pool2]
size = (900, 600)
fig = Figure(; size = size)
ax = Axis(fig[1, 1]; xlabel = "Time", ylabel = "Concentration", title = "Example 4.2")
for sp in species_and_observables
    lines!(ax, sol.t, sol[sp, :]; label = string(sp), linewidth = 2)
end
axislegend(ax; position = :rb, framevisible = false)
fig_filename = joinpath("sb2", "plots", "ex_4_2.png")
save(fig_filename, fig)
println("Wrote $fig_filename")
