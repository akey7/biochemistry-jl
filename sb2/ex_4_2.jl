using Catalyst
using CairoMakie
using DifferentialEquations

t = default_t()
@species begin
    x1(t)
    x2(t)
end
@parameters begin
    kf
    kr
end
rn = @reaction_network ex_4_2 begin
    kf*x1, x1 --> x2
    kr*x2, x2 --> x1
end
for rx in reactions(rn)
    println(rx)
end
