# 射の構造体
mutable struct Arrow
    dom::Any # 域 (domain)
    cod::Any # 余域 (codomain)
    # 内部コンストラクタ
    Arrow(dom::Any, cod::Any) = new(dom, cod)
end

# 等価性の定義
# domとcodが同じなら等価 (痩せた圏のため)
function Base.:(==)(arrow1::Arrow, arrow2::Arrow)::Bool
    arrow1_props = tuple([getproperty(arrow1, prop) for prop in propertynames(arrow1)]...)
    arrow2_props = tuple([getproperty(arrow2, prop) for prop in propertynames(arrow2)]...)
    return arrow1_props == arrow2_props
end
# ハッシュの定義
function Base.hash(arrow::Arrow, h::UInt)::UInt
    arrow_props = tuple([getproperty(arrow, prop) for prop in propertynames(arrow)]...)
    return hash(arrow_props, h)
end