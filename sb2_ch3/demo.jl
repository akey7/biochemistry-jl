using Catalyst

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
    Keq_v3_f
    k_v3_f
    # k_v3_r is omitted
end
rxs = [
    Reaction(k_v1_f*(x1 - x2/Keq_v1_f), [x1], [x2]),
    Reaction(k_v1_r*(x2 - x1/Keq_v1_r), [x2], [x1]),
    Reaction(k_v2_f*(x2 - x3/Keq_v2_f), [x2], [x3]),
    Reaction(k_v2_r*(x3 - x2/Keq_v2_r), [x3], [x2]),
    Reaction(k_v3_f * x3, [x3], [x4])
]
@named rn = ReactionSystem(rxs ,t)
rn = complete(rn)
for rx in rxs
    println(rx)
end
