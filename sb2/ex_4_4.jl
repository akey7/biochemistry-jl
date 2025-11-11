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
        Keq_1
        k1
        k2
        Keq_3
        k3
    end
    k1*(x2-x1/Keq_1), x1 --> x2
    k1*(x1-x2/(1/Keq_1)), x2 --> x1
    k2, x2 --> x3
    k3*(x4 - x3/Keq_3), x3 --> x4
    k3*(x3 - x4/(1/Keq_3)), x4 --> x3
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
