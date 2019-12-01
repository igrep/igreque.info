---
title: 独断と偏見によるHaskellの紹介（公開版）
author: 山本悠滋
date: 2016-03-22 Thanks God! It's Haskell day #0

---

※このスライドは、社内勉強会で使ったものを一部加工したものです。  
※理由はもう覚えてませんがが書きかけの箇所（「hoge」って書いてるところ）が何カ所かあります。

# はじめまして！

- 山本悠滋
- Twitterでは[\@igrep](https://twitter.com/igrep)。
- igrep.elというEmacsプラグインとは何の関係もありません！！！
- 好きなエディタはvim :)

# 私とHaskell

- 始めて4年程度
- 趣味で勉強し知識は溜め込むも書いた量は少ない
- 最近小さなスクリプトでも敢えて書いてみてる

# 私とHaskell

- [Haskellの勉強会](http://haskellmokumoku.connpass.com/)を毎月開催
- [HaskellJP Wiki](http://wiki.haskell.jp/)の現在の管理人
- ![](/imgs/2016-03-22-my-haskell-overview/haskelljp-wiki.png)

# お話しすること

1. FAQ
1. Javaはじめ他の言語との比較
1. Webアプリの開発と運用
1. Javaとの連携
1. 製品での事例紹介

# FAQ

- Haskellって何に使えるの？
- どういう形式で実行されるの？
- IDEは？
- オブジェクト指向っぽいことは？

# Haskellって何に使えるの？

普通に何でも書けます。

# Haskellって何に使えるの？

[ちょっとしたスクリプト](https://github.com/itchyny/sjsp)でも、

![](/imgs/2016-03-22-my-haskell-overview/itchyny-sjsp.png)

# Haskellって何に使えるの？

[Webサーバー](http://www.iij.ad.jp/company/development/tech/activities/mighttpd/)でも、

![](/imgs/2016-03-22-my-haskell-overview/mighty-iij.png)

# Haskellって何に使えるの？

[Wiki engine](http://gitit.net/)でも、

![](/imgs/2016-03-22-my-haskell-overview/gitit.png)

# Haskellって何に使えるの？

[ドキュメント変換器](http://pandoc.org/)でも、

![](/imgs/2016-03-22-my-haskell-overview/pandoc.png)

# Haskellって何に使えるの？

[静的サイトジェネレーター](https://jaspervdj.be/hakyll/)でも！

![](/imgs/2016-03-22-my-haskell-overview/hakyll.png)

# どういう形式で実行されるの？

- GHCの場合...
- ネイティブコードにコンパイルします。
    - Windowsでビルドすればexeファイルをそのまま配布できる！
- スクリプト言語のように実行することもできますが、実際にはビルドと実行を自動化してるだけ。

# IDEは？

- 試せているわけではないですが
    - `Leksah`
    - `IntelliJ`のプラグイン
- とかがあるようです。もちろん各種エディタプラグインも。

# オブジェクト指向っぽいことは？

- **恐らく**あなたがやりたいことは大体できます（個人の感想です）

# オブジェクト指向っぽいことは？

（いわゆる、自然に存在するもののアナロジーで）  
ふっつーに新しいデータ型を定義できますし、

```haskell
data Shape =
  Rectangle
    { height :: Double, width :: Double }
  | Circle
    { radius :: Double }
```

# オブジェクト指向っぽいことは？

moduleからexportしないことで、データ構造の隠蔽もできます。

```haskell
module Shape
  ( Shape -- こっちがpublic
  , publicFuncA
  , publicFuncB
  ) where

-- exportしない方がprivate
func :: Shape -> Foo
func shape = ...
```

# オブジェクト指向っぽいことは？

「型クラス」という、インターフェースと似たものもあります。

```haskell
class Comparable a where
  compareTo :: a -> a -> Int
```

- あの、Monadもその「型クラス」です！

# オブジェクト指向っぽいことは？

※実際には型クラスを使わずに高階関数をうまく使えば大抵要らない、  
という声も聞きますが、まぁやり方は人それぞれで。

# Javaはじめ他の言語と比べて良いところ

- もっと強く、優しい型
    - 「純粋な関数」と影響範囲のコントロール
- 数値リテラルまで多相型
- 超軽量なスレッド
- 超細かい最適化機構

# もっと強く、優しい型

- もっと強い型
    - 柔軟な型機能
    - 代数的データ型
- もっと優しい型
    - ScalaよりSwiftより型推論

# もっと強く、優しい型

- 曖昧で動的な自動変換はなし。
    - ルールを覚える必要なし！
    - うっかり間違えてハマる必要なし！
    - 継承もないからアップキャストだなんだでどの関数が呼ばれるか考える必要はなし
- どの関数が呼ばれるかはすべてコンパイル時に決まる！

# 数値リテラルまで多相型

10進数が捗る

```haskell
x :: Double  -- <- ここでDoubleと宣言しているから
x = 1 + 0.1  -- <- ここの2つの数値リテラルはDoubleになる

y :: Decimal -- <- ここでDecimalと宣言しているから
y = 1 + 0.1  -- <- ここの2つの数値リテラルはDecimalになる
```

# 影響範囲のコントロール

「純粋な関数」と「イミュータブルな変数」でコードの影響範囲をコントロール！

# 影響範囲のコントロール

そもそも「純粋な関数」って

- 戻り値が引数によってのみ定まる。
- 「戻り値を返す」以外になにもしない。
- Haskellでは型で純粋さを保証する。
    - `unsafePerformIO`というデバッグ用に作られた例外はあります。

# 影響範囲のコントロール

純粋な関数じゃない・変数がミュータブルだと

- 「状態」を持つと常に前後の影響を考えないといけない

# 影響範囲のコントロール

```java
Result fooResult = null;
// ...
x.setResult(fooResult);
```

- ↑その`result`, いつの`result`？ちゃんと処理した後の`result`？
    - 事前にあのメソッドは呼んだ？
    - そもそもnullのままになってない？
- `x`にsetした`result`はいつまで`fooResult`なの？

# 影響範囲のコントロール

変数がイミュータブルだと

```haskell
let fooResult = ...
-- ...
x { result = fooResult }
```

- ↑`fooResult`の定義を見たあとは参照している箇所だけに注目すればいい！
- 使用箇所だけが「影響範囲」だから！

# 影響範囲のコントロール

純粋な関数だと

- 常に「影響範囲」が明瞭！
- 戻り値にしか影響を与えないし、引数を変えなければ影響を受けない！

# 影響範囲のコントロール

とはいえ...

- 実際には手続き型なスタイルで書きたい場面もありますよね？
    - いちいち新しい変数名を割り当てるのがかったるい場合とか
    - 表現したい対象がStatefulだと捉えた方がしっくりくる場合とか
    - とかとか...

# 影響範囲のコントロール

そんな時に使えるの、あります。

- StateモナドやSTモナドを使えば「特定の変数だけ書き換え可能な」関数が作れます。
- そしてそれも関数の「型」として表現され、保証されます。

# とにかく純粋なJavaコード

```java
public int sum(int[] integers) {
    int result = 0;
    for (int i : integers) {
        result += i;
    }
    return result;
}
```

# 影響範囲のコントロール

安心してください！純粋ですよ！

- IOもしてないし！
- 特にインスタンス変数も書き換えてないし！
- やってることは`integers`を受け取ってその合計を返しているだけ！

# 影響範囲のコントロール

それを、そのまま翻訳したようなHaskellのコード

- ※余談ですがこの程度なら純粋な関数で書いたほうがいいです。

```haskell
sum :: [Int] -> Int
sum integers =
  (flip execState) 0 $ do
    forM_ integers $ \i -> do
      modify (+ i)
```

# 影響範囲のコントロール

- パッと見超手続きっぽいスタイルだけど「純粋な関数」。
- 状態を書き換えられる範囲を型で絞る。

# 影響範囲のコントロール

hoge: 前述のコードを色をつけて解説

# 影響範囲のコントロール

ほかにも...

- 指定した型の変数への「追記」のみができるWriter Monad
- 指定した型の変数の「読み込み」のみができるReader Monad
- 事実上なんでもできちゃうIO Monad

# 影響範囲のコントロール

すべては`Monad`というインターフェースと、  
do記法という構文糖によって実現されます。

# 影響範囲のコントロール

※詳細は一緒に勉強しましょう！ vim(\_ \_)mer  
とりあえず今回はこういうことができる、  
ということだけ覚えていただけると！

# 超軽量なスレッド

[Intro to Haskell for Erlangers](http://bob.ippoli.to/haskell-for-erlangers-2014/#/cost-of-concurrency)より:

![](/imgs/2016-03-22-my-haskell-overview/cost-of-concurrency.png)

# 超軽量なスレッド

<div style="text-align: center;">
圧倒的じゃないか我が軍は

![](/imgs/2016-03-22-my-haskell-overview/attoteki.jpg)
</div>

# 超軽量なスレッド

- GHC独自のグリーンスレッドとネイティブスレッドのハイブリッドで、すっごいコンカレンシー！
- 先ほど触れた[Mighttpd](http://www.iij.ad.jp/company/development/tech/activities/mighttpd/)でも生かされてます！

# 超細かい最適化機構

- [数ある最適化オプション](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/options-optimise.html)に加え...
- INLINEプラグマ:
    - 指定した関数をインライン化することを強制する

# 超細かい最適化機構（続き）

- RULESプラグマ:
    - 特定の組み合わせで使われた関数を、ルールに従って書き換える
    - 例: `map f (map g xs)` を `map (f . g) xs`にコンパイル時に変換
- SPECIALIZEプラグマ:
    - 多相関数に対し、特定の型の場合のみの別実装を定義する

# Javaはじめ他の言語と比べて悪いところ

- 遅延評価は諸刃の剣問題
- 拡張増えまくり問題
- やっぱり学習は難しい問題
- いろんな型の値を同じListに入れたい時問題

# 遅延評価は諸刃の剣問題

Haskellの関数は「必要なときだけ」呼び出される

```haskell
main = do
  let x = 1 + 2
  y <- getContents
  print x
```

# 遅延評価は諸刃の剣問題

この場合、`y`は必要ないので`getContents`は実行されず、入力から何も読み込まない！
hoge: 試す

# 遅延評価は諸刃の剣問題

何が嬉しいの？

- 大きなリストを「ちょっとずつ、必要な分だけ使う」のを自動化できる
- 今回はIOが絡んだ例を紹介します。

# 遅延評価は諸刃の剣問題

```haskell
main = do
  -- 標準入力を**全部**読んで、
  fileContents <- getContents
  -- 行で分割して、最初の5行だけ取って、
  let ls = take 5 (lines fileContents)
  -- 各行の先頭に"First 5 lines: "とつけて出力
  mapM_ putStrLn (map ("First 5 lines: " ++) ls)
```

hoge: 試す

# 遅延評価は諸刃の剣問題

- メモリ効率悪くない？
- 悪くない！
    - 「ファイルを読む処理」まで「必要になるまで」やらない！
    - 遅延IOと言います

# 遅延評価は諸刃の剣問題

- ←のような単純なケースでは遅延IOは便利なのですが..
- IOエラーまで遅延して発生したりとか、
- ソケットをたくさん開いたり閉じたりするプログラムが辛かったりとか、
- いろいろ厄介 `(;_;)`

# 遅延評価は諸刃の剣問題

IOが絡まない例でも...

# 遅延評価は諸刃の剣問題

↓のような連想配列があったとして  

```json
{
    "a": 1 + 2 + 3 + ...,
    "b": 4 + 5 + 6 + ...,
}
```

hoge

# 遅延評価は諸刃の剣問題

- `"a"`のキーの値を使用した時、初めて`1 + 2 + 3 ...`の部分が計算される。 
- `"b"`のキーの値を計算するための予約（「`thunk`」と呼びます）は  
  そのまま**メモリ上に残る**！
- しかもある部分が評価されたかどうか見るのが面倒で、デバッグ時に辛くなることが！

# 遅延評価は諸刃の剣問題

回避方法

- `seq`など遅延評価「しない」ための機能やライブラリを使う
- [もうすぐリリース予定のGHC 8.0](https://ghc.haskell.org/trac/ghc/wiki/Status/GHC-8.0.1)では、宣言したファイル内すべての計算を遅延評価「しない」ようにする拡張が出ます！
    - `Strict`, `StrictData`

# やっぱり学習は難しい問題

やっぱり、考え方を改めるのは難しいです。

- StateやSTがあるとは言ってもそれ自体の学習コストもありますし...。
- ちなみに、StateもSTも一つの変数を書き換えることしか想定していません。

# やっぱり学習は難しい問題

拡張クソ多い

# 拡張クソ多い

[とあるライブラリのソース](https://github.com/haskell-servant/servant/blob/b3af5a8d9592dab6b016f3d7f9ec18253db10bb4/servant-server/src/Servant/Server/Internal.hs)

# 拡張クソ多い

!!?

```haskell
{-# LANGUAGE CPP                        #-}
{-# LANGUAGE ConstraintKinds            #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE FlexibleContexts           #-}
-- ...
{-# LANGUAGE TypeOperators              #-}
```

# 拡張クソ多い

- 「標準機能では物足りない！」と感じたGHCの開発者がガシガシ追加した！
- 内容は主に
    - 型の柔軟性を高め、より「融通がきく」ようにする機能
    - ちょっとした構文の拡張
    - などなど
- ファイルやパッケージ単位で有効・無効を切り替えられる。

# 拡張クソ多い

- もちろんすべて使いこなす必要も知る必要もありません！
- ...が、ものを見ると結構面食らいますよね...。

# いろんな型の値を同じListに入れたい時問題

Javaでは普通にできる下記のようなこと

```java
CharSequence[] strings = {
    "aaa",
    new StringBuilder("bbb")
};

for (String s: strings) {
    System.out.println(s.charAt(0).toString());
}
```

# いろんな型の値を同じListに入れたい時問題

- Haskellでやるのは不可能ではないですがやり方がいくつかあったりして難しいです。
- 「型クラス」はインターフェースと似てますが「型」そのものではないため、型クラスが同じだからといって同じ配列にいれることはできません。
- 汎用性の高いライブラリを作るときなどにちょっと工夫がいるかも知れません。

# Webアプリの開発と運用

- 開発環境の構築
- Webサーバー事情
- デプロイと監視

# 開発環境の構築

- [Haskell Platform](https://www.haskell.org/platform/)か
- [stack](http://docs.haskellstack.org/en/stable/README/)を使います。

# 開発環境の構築

- Haskell Platformは従来の方法。
    - 本でもこちらが紹介されていることが多い。
- 最近ではstackが主流になりつつある。
    - 個人的にもオススメ。

# なぜstack?

詳細は割愛しますが...

- 従来の(Haskell Platformに付いてる)パッケージマネージャー `cabal`の問題をほぼ根絶。
    - ライブラリを入れた組み合わせや順番によって、依存関係関係が解決できなくなっちゃう！
    - いわゆる「cabal hell」

# なぜstack?

- 複数のバージョンのGHCを入れるのが簡単
- 依存パッケージのバージョンを管理しやすい
- GitHubなどにしか上がっていないパッケージに依存するのも簡単

# Webサーバー事情

- WAI: Web Application Interface
    - Rubyでいうところのrack, PythonでいうところのWSGI
    - アプリをいろんなWebサーバーで動かすためにインターフェースを抽象化

# Webサーバー事情

- Warp
    - WAIのバックエンドとして通常使われる、スタンドアロンなWebサーバー。
    - HTTP/2もサポート済みだそうです。
    - [mighttpd](https://github.com/kazu-yamamoto/mighttpd2)もWarpベース。

# Webサーバー事情

フレームワークもいろいろありますが個人的に気になっているのを挙げますと

- [Spock](https://www.spock.li/)
    - いわゆる「Sinatra inspired」なので簡単♪
- [Servant](http://haskell-servant.readthedocs.org/en/stable/)
    - REST APIに特化。
    - 型でルーティングテーブルを宣言するとドキュメントからクライアントまで自動生成。

# デプロイと監視

デプロイ時は、

- 実行ファイルを乗せてデーモンとして起動してください。
- 普通にコンパイルすると静的にリンクされるはず。
    - だからバイナリサイズが大きくなりがち
- クロスコンパイルは面倒くさそうなのでサーバーの環境は揃えましょう。

# デプロイと監視

Apacheなどに載せる場合はwai-handler-fastcgiが正解っぽいです。

# デプロイと監視

以下はメモリのお話だけですが監視についても。

- GCの使用状況などは[ekg](https://github.com/tibbe/ekg)と各種バックエンドを使えばリアルタイムにわかるそうです。
- GHCが提供する各種プロファイリングオプションを駆使しましょう。
- 詳しくは[GHCヒーププロファイリングの手引き](https://medium.com/@maoe/ghc%E3%83%92%E3%83%BC%E3%83%97%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%AE%E6%89%8B%E5%BC%95%E3%81%8D-md-bb8d180230f6#.itae6y37s)が参考になります。

# Javaとの連携

- Message Queueは？
- FFIは？

# Message Queueは？

- メッセージキューを使う場合、ActiveMQやZeroMQ, RabbitMQを介するライブラリが紹介されていました。
    - [Java Message Service and Haskell - Stack Overflow](http://stackoverflow.com/questions/3159673/java-message-service-and-haskell)

# FFIは？

[call-haskell-from-anything](https://github.com/nh2/call-haskell-from-anything)というのも見つけました。

- FFIを利用して、C言語レベルでの関数を`.so`ファイルとして作成
- データのやり取りは全て**msgpackを経由**することで、Cのデータ構造を意識せずに使えるようにする、というもの。

# Haskellの事例紹介

- 新日鉄住金ソリューションズ
- NTTデータ
- 朝日ネット

# Haskellの事例紹介

新日鉄住金ソリューションズ

- [Javaはもう古い！次の主流は「関数型」 - ［Haskell］関数型の特徴を満載した王道の言語：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20130112/449224/)
- ![](/imgs/2016-03-22-my-haskell-overview/shin-nittetsu.png)

# Haskellの事例紹介

新日鉄住金ソリューションズ

> 同社は金融機関向けの時価会計パッケージ製品「BancMeasure」をHaskellで開発した。HaskellではJavaなどと比べて短い記述が可能なため比較は難しいが、コード行数は約2万3000ステップである。プロジェクト発足時にはJavaのスキルしか持たなかった同社の10人の開発人員が、Haskellの習得期間を含めて約6カ月で製品を完成させた。

# Haskellの事例紹介

新日鉄住金ソリューションズ

> 単体テストの効率も向上させることができた。Haskellはコンパイラによるチェック機能が豊富なため、コンパイルが成功した後は、通常の単体テストで検出するようなバグはほとんど発生しなかったからだ。Javaでは1時間コーディングすると、単体テストやデバッグに1～3時間ほどを要するという。これらを総合し、実装工程だけで比べるとHaskellについて言われている「Javaの10倍の生産性というのは嘘ではないと実感できた」

# Haskellの事例紹介

NTTデータ

- [古くて新しいプログラミングパラダイム～関数型プログラミング | NTTデータ](http://www.nttdata.com/jp/ja/insights/trend_keyword/2013032101.html)
- ![](/imgs/2016-03-22-my-haskell-overview/ntt-data.png)

# Haskellの事例紹介

NTTデータ

> NTTデータでは、レガシーシステムのリバースエンジニアリングツールの開発においてHaskellを利用しています。レガシーシステムのリバースエンジニアリングを行うには多様なプログラミング言語の解析を行う必要があり、解析対象のプログラミング言語に合わせて、一部の機能を修正したり入れ替えたりすることが多いため、関数型プログラミングの利点を大きく享受できることが理由です。

# Haskellの事例紹介

朝日ネット

- まだ記事にはなってないですが...
- いつも[私の勉強会](http://haskellmokumoku.connpass.com/)のために会場を貸していただいているISPさん

# Haskellの事例紹介

朝日ネット

- [\@khibino](https://twitter.com/khibino)さんが[unixパッケージ](http://hackage.haskell.org/package/unix)を読んで完成度の高さに感動。
- Perl に代わる、Unix レイヤーと Java の間の glue コードを書くための言語を検討していたそうで。

# Haskellの事例紹介

朝日ネット

- 努力実り、現在はISPの認証サーバーを実装し、実運用中！
- 朝日ネットの会員さんのアクセスの何%かはHaskellが捌いています！！

# これから使う予定のテキスト

今回は↓を使います！

- [関数プログラミング実践入門 ──簡潔で，正しいコードを書くために](http://gihyo.jp/book/2014/978-4-7741-6926-2)
- <a href="http://www.amazon.co.jp/gp/product/4774169269/ref=as_li_ss_il?ie=UTF8&amp;camp=247&amp;creative=7399&amp;creativeASIN=4774169269&amp;linkCode=as2&amp;tag=poe02-22"><img border="0" src="http://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&amp;ASIN=4774169269&amp;Format=_SL110_&amp;ID=AsinImage&amp;MarketPlace=JP&amp;ServiceVersion=20070822&amp;WS=1&amp;tag=poe02-22" ></a><img src="http://ir-jp.amazon-adsystem.com/e/ir?t=poe02-22&amp;l=as2&amp;o=9&amp;a=4774169269" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

# これから使う予定のテキスト

- 私がちゃんと読んだことがないから
- [すごいH本](https://estore.ohmsha.co.jp/titles/978427406885P)を前職での勉強会で使用したけど、個人的に不満もあったので。
- すごいH本より内容も新しめですし！

# これから使う予定のテキスト

- 「GMOすごいエンジニア支援制度」の「学ぼうぜ！」を使ってみるのもいいかもしれません！
- ![](/imgs/2016-03-22-my-haskell-overview/gmo-manabo.gif)
    - 「技術関連の書籍や最新ガジェットの購入、開発合宿への参加費など、スキルアップに繋がることであれば年間10万円を上限に費用を補助するプログラム」
- ...が、GMOインターネットの社員しか使えないそうです...。

# まとめ

- Haskellは型が強く、優しい！
    - コードを簡潔に保ちつつ、
    - コンパイラにバグ発見してもらえる！
- めっちゃスレッド増やせる！
- 実は手続きっぽいスタイルでも書けちゃう！

# さらにまとめ

つまり！

- バグの出しにくさ
- 高速さ
- 書きやすさ
- を、兼ね揃えた言語！
