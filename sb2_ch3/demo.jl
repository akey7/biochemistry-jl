using Catalyst, OrdinaryDiffEqTsit5, Plots
using CairoMakie, GraphMakie, NetworkLayout

rn = @reaction_network sb2_ch3_ex begin
    @species begin
        x1(t)
        x2(t)
        x3(t)
        x4(t)
    end

    @parameters begin
        k_v1_f
        k_v1_r
        k_v2_f
        k_v2_r
        k_v3_f
        # k_v3_r is omitted
    end

    (k_v1_f, k_v1_r), x1 <--> x2
    (k_v2_f, k_v2_r), x2 <--> x3
    k_v3_f, x3 --> x4
end

println(rn.rxs)
