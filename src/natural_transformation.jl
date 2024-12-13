# 関手の対応づけが自然変換をなしているかを判定する関数
function is_natural(C::ThinCategory, t_mapping::Dict{Any, Arrow}, F_mapping::Dict{Any, Any}, G_mapping::Dict{Any, Any})::Bool
    F = x -> F_mapping[x]
    G = x -> G_mapping[x]
    t = x -> t_mapping[x]
    for arrow in C.arrows
        # 合成可能か & 可換性を満たしているか
        if !(t(arrow.dom).cod ==  G(arrow).dom && # 合成できるか ↓→
            F(arrow).cod == t(arrow.cod).dom && # 合成できるか →↓
            G(arrow).cod == t(arrow.cod).cod) # 行き先が同じか
            return false
        end
    end
    return true
end