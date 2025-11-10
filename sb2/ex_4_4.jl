using Catalyst
using CairoMakie
using DifferentialEquations

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
        k1_r
        k2_f
        k3_f
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
osys = convert(ODESystem, rn)
for eq in equations(osys)
    println(eq.rhs)
end
