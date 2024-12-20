# 2つの関手が自然変換をなしているかを判定する関数
function is_natural(C::ThinCategory, F_mapping::Dict{Any, Any}, G_mapping::Dict{Any, Any})::Bool
    F = x -> F_mapping[x]
    G = x -> G_mapping[x]

    # 自然変換
    ϑ_mapping = Dict{Any, Arrow}(
        (obj, Arrow(F(obj), G(obj))) for obj in C.objects
    )
    ϑ = x -> ϑ_mapping[x]
    for arrow in C.arrows
        # 合成可能か & 可換性を満たしているか
        if !(ϑ(arrow.dom).cod ==  G(arrow).dom && # 合成できるか ↓→
            F(arrow).cod == ϑ(arrow.cod).dom && # 合成できるか →↓
            G(arrow).cod == ϑ(arrow.cod).cod) # 行き先が同じか
            return false
        end
    end
    return true
end