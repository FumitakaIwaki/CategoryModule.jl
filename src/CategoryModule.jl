module CategoryModule
export 
    Arrow,
    ThinCategory, has_arrow, get_identity_arrows, get_non_identity_arrows, compose, compose!,
    is_functorial, find_functors,
    is_natural

include("./arrow.jl")
include("./category.jl")
include("./functor.jl")
include("./natural_transformation.jl")
end # module CategoryModule
