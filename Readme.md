# CategoryModule.jl
以下の記事で使用したコードです．


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
    `$ git clone git@github.com:FumitakaIwaki/CategoryModule.jl.git`
3. cloneしたディレクトリ内に入る  
    `$ cd <path to CategoryModule.jl>`
4. juliaを起動する  
    `$ julia`
5. `]`を入力し，juliaのpkgモードに入る
6. `activate`コマンドでProject環境を起動する  
    `(@v1.11) pkg> activate .`
7. `test`コマンドでテストを実行し動作確認する  
    `(CategoryModule) pkg> test`

### モジュールの追加
1. `activate`コマンドで一度環境から抜ける  
    `(CategoryModule) pkg> activate`
2. `develop`コマンドでモジュールを追加する  
    `(@1.11) pkg> develop <path to CategoryModule.jl>`  
    こうすることで環境の外から`using CategoryModule`でモジュールをimportできるようになる  
    `(@1.11) pkg> rm CategoryModule`でいつでも削除できる
3. `status`コマンドで`CategoryModule`が追加されているのを確認できればok  
    `(@1.11) pkg> status`

### サンプルコードの実行
1. `backspace`を入力しpkgモードからREPLモードに戻る
2. `include`関数で`sample.jl`を取り込む  
    `julia> include("sample.jl")`
3. `sample.jl`の`main`関数を実行する
    `julia> main()`
4. 出力結果を確認する