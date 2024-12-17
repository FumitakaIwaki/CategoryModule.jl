# 射の構造体
mutable struct Arrow{T}
    dom::T # 域 (domain)
    cod::T # 余域 (codomain)
    # 内部コンストラクタ
    Arrow(dom::Any, cod::Any) = new{Any}(dom, cod)
    Arrow(dom::Int, cod::Int) = new{Int}(dom, cod)
    Arrow(dom::String, cod::String) = new{String}(dom, cod)
    Arrow(dom::Float64, cod::Float64) = new{Float64}(dom, cod)
    Arrow(dom::Symbol, cod::Symbol) = new{Symbol}(dom, cod)
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