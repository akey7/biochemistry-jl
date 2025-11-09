using Catalyst

t = default_t()
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
rxs = [
    Reaction(k_v1_f, [x1], [x2]),
    Reaction(k_v1_r, [x2], [x1]),
    Reaction(k_v2_f, [x2], [x3]),
    Reaction(k_v2_r, [x3], [x2]),
    Reaction(k_v3_f, [x3], [x4])
]
@named rn = ReactionSystem(rxs ,t)
println(rn.rxs)
