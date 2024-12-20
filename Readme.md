# CategoryModule.jl
圏論の基本概念を簡単に実装したモジュールです．

## 環境
|  |  |
| ---- | ---- |
| PC | MacBook Air M2 2022 8GB |
| Julia version | 1.11.1 |
| Editor | Visual Studio Code 1.95.3 (Universal) |

## モジュールの追加と動作確認
Juliaのインストールは済んでいる前提です．  
パスも通し，シェルから`julia`コマンドでJuliaを起動できる状態になっていることを想定しています．

### 動作確認
1. juliaのパスを通したシェルを起動する
2. このリポジトリをclone  
```
$ git clone git@github.com:FumitakaIwaki/CategoryModule.jl.git
```
3. cloneしたディレクトリに移動する
4. `$ julia`でjuliaを起動する  
5. `]`を入力し，juliaのpkgモードに入る
6. Project環境を起動する  
```
(@v1.11) pkg> activate .
```
7. テストを実行し動作確認する  
```
(CategoryModule) pkg> test
```

### モジュールの追加
1. 一度環境から抜ける  
```
(CategoryModule) pkg> activate
```
2. モジュールを環境に追加する  
    こうすることで環境の外から`using CategoryModule`でモジュールをimportできるようになる  
```
(@v1.11) pkg> develop <path to CategoryModule.jl>  

# 環境から削除する場合
(@v1.11) pkg> rm CategoryModule
```

3. 以下のコマンドで`CategoryModule`が追加されているのを確認できればok  
```
(@v1.11) pkg> status
```

### サンプルコードの実行
1. `backspace`を入力しpkgモードからREPLモードに戻る
2. REPLで`sample.jl`を取り込む  
```
julia> include("sample.jl")
```
3. `sample.jl`の`main`関数を実行する
```
julia> main()
```
4. 出力結果を確認する