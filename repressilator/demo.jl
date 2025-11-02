# From Catalyst.jl docs:
# https://docs.sciml.ai/Catalyst/stable/introduction_to_catalyst/introduction_to_catalyst/

using Catalyst, OrdinaryDiffEqTsit5, Plots
using CairoMakie, GraphMakie, NetworkLayout

rn = @reaction_network Repressilator begin
    hillr(P₃,α,K,n), ∅ --> m₁
    hillr(P₁,α,K,n), ∅ --> m₂
    hillr(P₂,α,K,n), ∅ --> m₃
    (δ,γ), m₁ <--> ∅
    (δ,γ), m₂ <--> ∅
    (δ,γ), m₃ <--> ∅
    β, m₁ --> m₁ + P₁
    β, m₂ --> m₂ + P₂
    β, m₃ --> m₃ + P₃
    μ, P₁ --> ∅
    μ, P₂ --> ∅
    μ, P₃ --> ∅
end

println(species(rn))
println(parameters(rn))
println(reactions(rn))
g = plot_network(rn)
save("repressilator_graph.png", g)
odesys = convert(ODESystem, rn)
pmap  = (:α => .5, :K => 40, :n => 2, :δ => log(2)/120,
         :γ => 5e-3, :β => log(2)/6, :μ => log(2)/60)
u₀map = [:m₁ => 0., :m₂ => 0., :m₃ => 0., :P₁ => 20., :P₂ => 0., :P₃ => 0.]
tspan = (0., 10000.)
println("Creating ODEProblem")
oprob = ODEProblem(rn, u₀map, tspan, pmap)
println("Solving ODEs")
sol = solve(oprob, Tsit5(), saveat=10.0)
display(Plots.plot(sol))
println("Press enter to exit...")
readline()
