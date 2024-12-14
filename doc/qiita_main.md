これは「<font color=Purple>**imtakalab Advent Calendar 2024**</font>」の18日目の記事です．

https://adventar.org/calendars/10354

# 概要
筆者は現在情報学専攻の修士学生です．所属している研究室でJuliaを普及させたいという秘めた野望があるのですが全く流行らず，日々力不足を感じています．

筆者の周囲では，計算機でのシミュレーション実験のコードなどをPythonで書いている学生が多いです．Pythonは汎用的で使いやすい言語ですが，場合によっては速度が不十分だったり，数学概念の記述が直感的でなかったりします．

科学計算に強く，優れた型システムを持ち，強力な多重ディスパッチを備え，動的型付け言語でありながらCに迫る速度を出せるJuliaの有用性を本記事で伝えられればなと思います．

# Juliaについて
Juliaはマサチューセッツ工科大学で開発された言語です．  
その特徴は「Pythonのように書けて，Cのように動く」ことです[^1]．普段Pythonを使用している方はすぐに習得できると思います．  
開発者らは，Juliaを作った理由について「We are greedy: we want more.」と述べています[^2]．開発者たちのブログからは，彼らの熱意とオタク具合がよく伝わってきます．

JuliaのインストールにはJuliaupという公式のバージョン管理ツールを使用することをおすすめします．pyenvのような感じです．

https://note.com/mk_o/n/n3d3f75c1edca

開発環境はVS Codeがおすすめです．うまく動かない場合はVS Codeの設定の`Julia: Executable Path`を確認してみてください．

https://www.zakioka.net/blog/julia-intro-install/

また，開発を進める際はProject環境を用いて自作パッケージにするといいでしょう．仮想環境のような感じです．  
VS Code画面の左下にある`Julia env:`から作成したProject環境を選択するとその環境でコードを実行できます．

https://zenn.dev/h_shinaoka/articles/23bdbc257f3ee7

VS CodeでJupyterカーネルを使えるようにしておけば，IJuliaパッケージをインストールすることでnotebook環境でJuliaを使用することも可能です．  
カーネルとしてインストールしたJuliaのみ選択可能で，先述のように`Julia env:`でProject環境を選択するとその環境でコードを動かせます．

https://zenn.dev/dannchu/articles/44c981b37c28a7

# 圏論について
Juliaを用いた実装例として，圏論という数学理論の一部の基本的概念を取り扱いたいと思います．

圏論 (category theory) とは，数学的構造とその間の関係を抽象的に扱う数学理論の一つです[^3]．  
数学者のSteve Awodeyは著書で「圏論とは何か？」という問いに「関数の（抽象）代数の数学的研究である」と答えています[^4]．  
本記事では圏論の概念のうち，圏 (category)，対象 (object)，射 (arrow)，関手 (functor)，自然変換 (natural transformation) を扱います．

筆者は決して数学に強いわけではなく圏論もまだまだ勉強中のため，お手柔らかに最後までお付き合いいただけると幸いです．

# 実装と解説
こちらが本記事を書くにあたって作成したコードです．

https://github.com/FumitakaIwaki/CategoryModule.jl

Juliaの開発環境を整備した後，Readmeに沿って実行してもらえば動かせると思います．

## 圏，対象，射
圏とは，対象と射からなるシステムです[^5]．

:::note
Definition 1. 圏は以下の要素から構成される．
- 対象 (Objects): $A, B, C, ...$
- 射 (Arrows): $f, g, h, ...$
- 各射は域 (domain)と余域 (codomain) と呼ばれる対象を持つ．
    $$dom(f), ~~cod(f)$$
     - $f: A \rightarrow B$ は，$A = dom(f)$ かつ $B = cod(f)$ であることを示す．
- $cod(f) = dom(g)$ である射$f: A \rightarrow B$ と射 $g: B \rightarrow C$ が与えられたとき，$f$と$g$の合成射が存在する．
    $$g \circ f: A \rightarrow C$$
- 各対象には恒等射が存在する．対象$A$の恒等射は以下のように書く．
    $$1_A: A \rightarrow A$$
- 上記の要素は以下の法則に従う．
    - 結合律 (Associativity): 射$f: A \rightarrow B$，$g: B \rightarrow C$，$h: C \rightarrow D$について
    $$h \circ (g \circ f) = (h \circ g) \circ f$$
    - 単位律 (Unit): 射$f: A \rightarrow B$について
    $$f \circ 1_A = f = 1_B \circ f$$
:::

圏の中身は上の定義を満たしていれば何でもいいです．  
今回は半順序集合 (poset) を例に話を進めたいと思います．

### 射の実装
`dom`と`cod`をpropertyに持つ構造として射を定義します．  
対象は何でも良いということで`Any`型にしています．
```julia
mutable struct Arrow
    dom::Any # 域 (domain)
    cod::Any # 余域 (codomain)
    # 内部コンストラクタ
    Arrow(dom::Any, cod::Any) = new(dom, cod)
end
```

### 圏の実装
対象の集合`objects`と射の集合`arrows`をpropertyに持つ構造体として圏を定義します．  
内部コンストラクタは複数作成したのですが，ここでは一部のみ載せています．
```julia
# 痩せた圏
mutable struct ThinCategory <: AbstractCategory
    objects::Set{Any}
    arrows::Set{Arrow}
    # 内部コンストラクタ
    function ThinCategory(objects::Set, arrows::Set{Arrow})
        arrows = copy(arrows)
        # 恒等射の追加
        for object in objects
            push!(arrows, Arrow(object, object))
        end
        new(objects, arrows)
    end
end
```

今回は痩せた圏と呼ばれる，domとcodが同じ射は高々一つしか存在しない圏を想定します．
したがって，射を集合で扱う上で等価性を定義する必要が出てきます．  
Juliaには多重ディスパッチという，同じ関数名でも引数に指定した型によって別々の関数を呼びさせることできるという強力な機能があります．つまり，標準搭載の`==`という演算子に`Arrow`型が引数のときの演算を追加できるということです．
```julia
# 等価性の定義
# domとcodが同じなら等価
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
```
SetやDictといったハッシュベースのコレクションに対応するため，`hash`関数も追加しています．  
こうすることで，`Arrow(1, 2) == Arrow(1, 2)`が`true`となるのはもちろん，`in`などの演算子もしっかり機能します．  
重複を含んだArrowの配列をSetにしてもちゃんと重複が無くなります．

多重ディスパッチにより，自身で定義した構造体をより自然な形で扱うことが可能になります．構造体に対して四則演算を自由に定義できるということなので，柔軟に群・環・体を表現することができます．  
また，引数によって処理を変えたい関数がある場合，中でif分岐するのではなく多重ディスパッチにすることで効率がよくなります．  

### 射の合成
入力の圏において可能な合成射を全て作成する関数です．  
今回`has_arrow`関数によるチェックは不要ですが，今後を考え一応入れました．
```julia
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
```

## 関手
関手とは2つの圏の間の対応づけです．  

:::note
Definition 2. 関手
$$F: \mathbf C \rightarrow \mathbf D$$
は圏$\mathbf C$から圏$\mathbf D$の，対象は対象へ，射は射への以下の条件を満たしたマッピングである．  
- 域と余域の保存: $F(f: A \rightarrow B) = F(f): F(A) \rightarrow F(B)$
- 恒等射の保存: $F(1_A)$ = $1_{F(A)}$
- 合成の保存: $F(g \circ f) = F(g) \circ F(f)$ 
:::

関手$F$が圏$\mathbf C$の射$f: A \rightarrow B$を圏$\mathbf D$の射$g: C \rightarrow D$に移すときは以下のように書けます．
$$
F(f) = g, ~~F(A) = C, ~~F(B) = D
$$

### 関手の実装
前述の通り，関手はマッピングであるためDictで十分です．  
作成した2つの圏間の射のマッピングが関手の条件を満たすかを判定する関数を作成しました．  
```julia
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
```

Juliaは関数の定義を`f = x -> 2x`というように簡単に行えます．これを利用して関手Fを関数として1行で定義できました．  
さらに，Juliaの描画機能ではこうした関数をそのまま描画関数に入力できます．例えばべき乗則をグラフに追加したいとき，非常に直感的なコードで描画できるというわけです．好き．

## 自然変換
自然変換とは2つの関手の対応づけです．

:::note
Definition3. 2つの圏$\mathbf C, \mathbf D$と$\mathbf C$から$\mathbf D$への2つの関手$F, G: \mathbf C \rightarrow \mathbf D$について，自然変換$\vartheta: F \rightarrow G$とは圏$\mathbf D$の射の族である．  
どんな圏$\mathbf C$の射$f: C \rightarrow C'$についても，$\vartheta_{C'} \circ F(f) = G(f) \circ \vartheta_C$をとなる．これは以下の図式が可換性を満たすということである．

![commutes_figure](latex/commutes_figure.png)

:::

[^1]: [「1から始めるJuliaプログラミング」 進藤 裕之, 佐藤建太 (コロナ社)](https://www.coronasha.co.jp/np/isbn/9784339029055/)
[^2]: ["Why We Created Julia" 14 Feb 2012, Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman](https://julialang.org/blog/2012/02/why-we-created-julia/)
[^3]: [圏論 - Wikipedia](https://ja.wikipedia.org/wiki/%E5%9C%8F%E8%AB%96)
[^4]: ["Category Theory -Second Edition-" 13 Aug 2010, Steve Awodey (Oxford University Press)](https://global.oup.com/academic/product/category-theory-9780199237180?cc=us&lang=en&)
[^5]: [「圏論の道案内 〜矢印でえがく数学の世界〜」 西郷 甲矢人，能美 十三 (技術評論社)](https://gihyo.jp/book/2019/978-4-297-10723-9)