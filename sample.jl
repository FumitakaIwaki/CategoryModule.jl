using CategoryModule

function main()
    # 圏の定義と射の合成
    C = compose(ThinCategory(["A" "B"; "B" "C"]))
    D = compose(ThinCategory(["D" "E";]))
    # 関手の列挙
    functors = find_functors(C, D)
    # 関手の辞書
    functor_dict = Dict{String, Dict{Any, Any}}()
    # 関手の表示
    println("Functors")
    for (i, functor) in enumerate(functors)
        id = "F" * string(i)
        println(repeat(" ", 3), id, ":")
        functor_dict[id] = functor
        for (dom, cod) in pairs(functor)
            println(repeat(" ", 6), dom, " => ", cod)
        end
    end
    # 自然変換の有無
    println()
    println("Natural tranformations")
    for (id1, f1) in pairs(functor_dict)
        for (id2, f2) in pairs(functor_dict)
            if id1 != id2
                if is_natural(C, f1, f2)
                    println(repeat(" ", 3), id1, " => ", id2)
                end
            end
        end
    end
end