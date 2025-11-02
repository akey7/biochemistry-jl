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
