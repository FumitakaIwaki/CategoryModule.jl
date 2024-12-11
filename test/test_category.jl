import CategoryModule:
    ThinCategory, has_arrow, get_identity_arrows, get_non_identity_arrows, compose!

@testset "ThinCategory" begin
    objects = Set([1, 2, 3])
    arrows = Set([Arrow(1, 2), Arrow(2, 3)])
    expected_arrows = Set([
        Arrow(1, 2), Arrow(1, 1), Arrow(3, 3), Arrow(2, 2), Arrow(2, 3)
    ])
    C = ThinCategory(objects, arrows)
    @test C.objects == objects
    @test C.arrows == expected_arrows

    C = ThinCategory(arrows)
    @test C.objects == objects
    @test C.arrows == expected_arrows
    
    expected_arrows = Set([Arrow(1, 1),  Arrow(2, 2), Arrow(3, 3)])
    C = ThinCategory(objects)
    @test C.objects == objects
    @test C.arrows == expected_arrows
end

@testset "has_arrow" begin
    arrows = Set([Arrow(1, 2), Arrow(2, 3)])
    C = ThinCategory(arrows)

    @test has_arrow(C, 1, 2)
    @test !has_arrow(C, 1, 3)
end

@testset "get_identity_arrows" begin
    arrows = Set([Arrow(1, 2), Arrow(2, 3)])
    C = ThinCategory(arrows)
    expected_arrows = Set([Arrow(1, 1),  Arrow(2, 2), Arrow(3, 3)])

    @test get_identity_arrows(C) == expected_arrows
end

@testset "get_identity_arrows" begin
    arrows = Set([Arrow(1, 2), Arrow(2, 3)])
    C = ThinCategory(arrows)
    expected_arrows = Set([Arrow(1, 2),  Arrow(2, 3)])

    @test get_non_identity_arrows(C) == expected_arrows
end

@testset "compose" begin
    arrows = Set([Arrow(1, 2), Arrow(2, 3)])
    C = ThinCategory(arrows)
    expected_arrows = Set([
        Arrow(1, 2)
        Arrow(1, 1)
        Arrow(3, 3)
        Arrow(1, 3)
        Arrow(2, 2)
        Arrow(2, 3)
    ])

    compose!(C)
    @test C.arrows == expected_arrows
end