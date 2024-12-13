import CategoryModule: is_natural

@testset "is_natural" begin
    C = compose(ThinCategory(["a" "b"; "b" "c"]))
    D = ThinCategory(["d" "e";])

    F_mapping = Dict{Any, Any}(
        "a" => "d",
        "c" => "e",
        Arrow("b", "c") => Arrow("d", "e"),
        Arrow("c", "c") => Arrow("e", "e"),
        "b" => "d",
        Arrow("a", "c") => Arrow("d", "e"),
        Arrow("a", "b") => Arrow("d", "d"),
        Arrow("b", "b") => Arrow("d", "d"),
        Arrow("a", "a") => Arrow("d", "d")
    )
    F = x -> F_mapping[x]

    G_mapping = Dict{Any, Any}(
        "a" => "d",
        "c" => "e",
        Arrow("b", "c") => Arrow("e", "e"),
        Arrow("c", "c") => Arrow("e", "e"),
        "b" => "e",
        Arrow("a", "c") => Arrow("d", "e"),
        Arrow("a", "b") => Arrow("d", "e"),
        Arrow("b", "b") => Arrow("e", "e"),
        Arrow("a", "a") => Arrow("d", "d")
    )
    G = x -> G_mapping[x]

    @test is_natural(C, F_mapping, G_mapping)

    G_mapping = Dict{Any, Any}(
        "a" => "d",
        "c" => "e",
        Arrow("b", "c") => Arrow("e", "e"),
        Arrow("c", "c") => Arrow("e", "e"),
        "b" => "e",
        Arrow("a", "c") => Arrow("e", "d"),
        Arrow("a", "b") => Arrow("d", "e"),
        Arrow("b", "b") => Arrow("e", "e"),
        Arrow("a", "a") => Arrow("d", "d")
    )
    G = x -> G_mapping[x]

    @test !is_natural(C, F_mapping, G_mapping)
end