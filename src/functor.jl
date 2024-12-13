# 射の対応づけのみの辞書に対象の対応づけも追加する関数
function add_objects_to_map(mapping::Dict{Arrow, Arrow})::Dict{Any, Any}
    object_mapping = Dict{Any, Any}()
    for (C_arrow, D_arrow) in pairs(mapping)
        object_mapping[C_arrow.dom] = D_arrow.dom
        object_mapping[C_arrow.cod] = D_arrow.cod
    end
    mapping = merge(mapping, object_mapping)

    return mapping
end

# 射の対応づけが関手をなしているかの検証
function is_functorial(C::ThinCategory, D::ThinCategory, mapping::Dict{Arrow, Arrow})::Bool
    # mappingにobjectも追加
    mapping = add_objects_to_map(mapping)
    # mappingから関手Fを作成 (写像の形で)
    F = x -> mapping[x]

    # 合成射を保存するか
    for arrow1 in C.arrows
        for arrow2 in Set(arrow for arrow in C.arrows if arrow.dom == arrow1.cod)
            # 圏Cの2つの射を関手Fで移した先でも合成可能かつその合成射が圏Dにあるか
            if !(F(arrow1).cod == F(arrow2).dom && has_arrow(D, F(arrow1).cod, F(arrow2).dom))
                return false
            end
        end
    end
    # 恒等射を保存するか
    for arrow in get_identity_arrows(C)
        obj = arrow.dom
        F_id = F(arrow)
        id_F = Arrow(F(obj), F(obj))
        if F_id != id_F
            return false
        end
    end
    return true
end

# 可能な関手を全て列挙する関数
function find_functors(C::ThinCategory, D::ThinCategory)::Set{Dict{Any, Any}}
    functors = Set{Dict{Any, Any}}()
    # 圏Cの射をtupleに (順序を担保するため)
    ntup_C_arrows = NTuple{length(C.arrows), Arrow}([arrow for arrow in C.arrows])
    # 圏Dの射の組み合わせ列挙
    for mapping in Iterators.product(fill(D.arrows, length(C.arrows))...)
        # mappingの作成
        mapping = Dict{Arrow, Arrow}(zip(ntup_C_arrows, mapping))
        # mappingが関手をなしているかの判定
        if is_functorial(C, D, mapping)
            # trueなら関手の一つとして追加
            push!(functors, add_objects_to_map(mapping))
        end
    end
    return functors
end