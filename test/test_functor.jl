import CategoryModule:
    add_objects_to_map, is_functorial, find_functors,
    compose

@testset "add_objects_to_functor" begin
    C = ThinCategory(["a" "b";])
    D = ThinCategory(["c" "d";])
    f_mapping = Dict{Arrow, Arrow}(
        Arrow("a", "a") => Arrow("c", "c"),
        Arrow("b", "b") => Arrow("d", "d"),
        Arrow("a", "b") => Arrow("c", "d")
    )
    expected_mapping = Dict{Any, Any}(
        "a" => "c",
        "b" => "d",
        Arrow("a", "a") => Arrow("c", "c"),
        Arrow("b", "b") => Arrow("d", "d"),
        Arrow("a", "b") => Arrow("c", "d")
    )

    @test add_objects_to_map(f_mapping) == expected_mapping
end

@testset "is_functorial" begin
    C = compose(ThinCategory(["a" "b"; "b" "c"]))
    D = ThinCategory(["d" "e";])

    f_mapping = Dict{Arrow, Arrow}(
        Arrow("a", "a") => Arrow("d", "d"),
        Arrow("b", "b") => Arrow("d", "d"),
        Arrow("a", "b") => Arrow("d", "d"),
        Arrow("a", "c") => Arrow("d", "e"),
        Arrow("b", "c") => Arrow("d", "e"),
        Arrow("c", "c") => Arrow("e", "e")
    )
    @test is_functorial(C, D, f_mapping)

    f_mapping = Dict{Arrow, Arrow}(
        Arrow("a", "a") => Arrow("d", "d"),
        Arrow("b", "b") => Arrow("d", "d"),
        Arrow("a", "b") => Arrow("d", "e"),
        Arrow("a", "c") => Arrow("d", "e"),
        Arrow("b", "c") => Arrow("d", "e"),
        Arrow("c", "c") => Arrow("e", "e")
    )
    @test !is_functorial(C, D, f_mapping)
end

@testset "find_functors" begin
    C = ThinCategory(["a" "b";])
    D = ThinCategory(["c" "d";])
    expected_functors = Set([
        Dict{Any, Any}(
            "a" => "c",
            "b" => "c",
            Arrow("a", "a") => Arrow("c", "c"),
            Arrow("b", "b") => Arrow("c", "c"),
            Arrow("a", "b") => Arrow("c", "c")
        ),
        Dict{Any, Any}(
            "a" => "d",
            "b" => "d",
            Arrow("a", "a") => Arrow("d", "d"),
            Arrow("b", "b") => Arrow("d", "d"),
            Arrow("a", "b") => Arrow("d", "d")
        ),
        Dict{Any, Any}(
            "a" => "c",
            "b" => "d",
            Arrow("a", "a") => Arrow("c", "c"),
            Arrow("b", "b") => Arrow("d", "d"),
            Arrow("a", "b") => Arrow("c", "d")
        )
    ])

    @test find_functors(C, D) == expected_functors
end