abstract type AbstractCategory end

# 痩せた圏
mutable struct ThinCategory <: AbstractCategory
    objects::Set{Any}
    arrows::Set{Arrow}

    # 内部コンストラクタ
    # 対象と射を入力として生成
    function ThinCategory(objects::Set, arrows::Set{Arrow})
        arrows = copy(arrows)
        # 恒等射の追加
        for object in objects
            push!(arrows, Arrow(object, object))
        end
        new(objects, arrows)
    end
    # 対象のみを入力として生成
    function ThinCategory(objects::Set)
        arrows = sizehint!(Set{Arrow}(), length(objects))
        #　恒等射の追加
        for object in objects
            push!(arrows, Arrow(object, object))
        end
        new(objects, arrows)
    end
    # 射のみを入力として生成
    function ThinCategory(arrows::Set{Arrow})
        arrows = copy(arrows)
        objects = Set([arrow.dom for arrow in arrows]) ∪ Set([arrow.cod for arrow in arrows])
        # 恒等射の追加
        for object in objects
            push!(arrows, Arrow(object, object))
        end
        new(objects, arrows)
    end
    # 辺リストのMatrixを入力として生成
    function ThinCategory(arrows::Array)
        arrows = copy(arrows)
        objects = Set(arrows)
        arrows = Set([Arrow(dom, cod) for (dom, cod) in eachrow(arrows)])
        # 恒等射の追加
        for object in objects
            push!(arrows, Arrow(object, object))
        end
        new(objects, arrows)
    end
end

# シャローコピー
function Base.copy(C::ThinCategory)::ThinCategory
    return ThinCategory(C.objects, C.arrows)
end

# 2つの対象間に射があるか調べる関数
function has_arrow(C::ThinCategory, dom::Any, cod::Any)::Bool
    return Arrow(dom, cod) in C.arrows
end

# 圏の恒等射を取得する関数
function get_identity_arrows(C::ThinCategory)::Set{Arrow}
    return Set(arrow for arrow in C.arrows if arrow.dom == arrow.cod)
end

# 圏の恒等射以外を取得する関数
function get_non_identity_arrows(C::ThinCategory)::Set{Arrow}
    return Set(arrow for arrow in C.arrows if arrow.dom != arrow.cod)
end

# 射の合成をする関数
# 可能な合成を全て実施
function compose(C::ThinCategory)::ThinCategory
    C = copy(C)
    for arrow1 in C.arrows
        for arrow2 in Set(arrow for arrow in C.arrows if arrow.dom == arrow1.cod)
            # すでに射がある場合は除外
            if !has_arrow(C, arrow1.dom, arrow2.cod)
                # 射の追加
                push!(C.arrows, Arrow(arrow1.dom, arrow2.cod))
            end
        end
    end
    return C
end
# 同様の処理を破壊的に
function compose!(C::ThinCategory)
    for arrow1 in C.arrows
        for arrow2 in Set(arrow for arrow in C.arrows if arrow.dom == arrow1.cod)
            # すでに射がある場合は除外
            if !has_arrow(C, arrow1.dom, arrow2.cod)
                # 射の追加
                push!(C.arrows, Arrow(arrow1.dom, arrow2.cod))
            end
        end
    end
end