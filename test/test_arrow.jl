import CategoryModule: Arrow

@testset "Arrow" begin
    dom, cod = 1, 2
    arrow = Arrow(dom, cod)

    @test arrow.dom == dom
    @test arrow.cod == cod
end

@testset "equivalence" begin
    dom, cod = 1, 2
    arrow1 = Arrow(dom, cod)
    arrow2 = Arrow(dom, cod)
    arrow3 = Arrow(cod, dom)

    @test arrow1 == arrow2
    @test arrow1 != arrow3

    @test Set([arrow1, arrow2, arrow3]) == Set([arrow1, arrow3])

    dict = Dict{Arrow, Int}(arrow1 => 10)
    dict[arrow2] = 100
    @test dict[arrow1] == 100
end