% substring-parserでcure-index.jsonを移行した話
% Yuji Yamamoto (山本悠滋)
% 2018/08/18 プリキュアハッカソン NewStage

# はじめまして！ (\^-\^)

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約6年。
- ちょっと前まで趣味Haskellerだったが今は仕事でもほぼHaskell @ [IIJ-II](https://www.iij-ii.co.jp/) 😄
- igrep.elというEmacsプラグインがありますが無関係です！

# 宣伝 hask(\_ \_)eller

- 去年から[日本Haskellユーザーグループ](https://haskell.jp/)というコミュニティーグループを立ち上げ、その発起人の一人として活動しております。
    - 愛称: Haskell-jp
- [Slackのワークスペース](https://haskell-jp.slack.com/)や[Subreddit](https://www.reddit.com/r/haskell_jp/)、[ブログ](https://haskell.jp/)、[Wiki](http://wiki.haskell.jp/)など、いろいろ運営しております。
- 次回、[Haskell-jpもくもく会 @ 朝日ネット](https://haskell-jp.connpass.com/event/96588/)は**ちょうど1週間後 08/25(土)**です！

# 今日のテーマ

- 「タイプセーフプリキュア！」の副産物である `cure-index.json` を完成させた話です
- Haskell界に伝わる伝説のアイテム「パーサーコンビネーター」を応用して、  
  「タイプセーフプリキュア！」の古いソースコードを半自動で変換しました

# 「タイプセーフプリキュア！」とは？

- [rubicure](https://github.com/sue445/rubicure)や[ACME::PrettyCure](https://github.com/kan/p5-acme-prettycure)のような「プリキュア実装」の1つです
    - プリキュアやプリキュアに変身する女の子たち、変身時の台詞などをソースコードに収録したライブラリー
- Haskellが好きなのでHaskellで書きました
- 詳しくはこの辺👇の記事を参照されたし
    - <http://the.igreque.info/posts/2016/06-type-safe-precure.html>
    - <https://qiita.com/igrep/items/5496fa405fae00b5a737>

# 「タイプセーフプリキュア！」とは？

軽いデモ

```
$ stack exec ghci -- -interactive-print="Text.Show.Unicode.uprint"
> import ACME.PreCure
> printEpisode $ transform (Mirai, Liko) (Mofurun LinkleStoneDia)
```

# cure-index.json とは？

詳しくはこっち👇に書きましたがここでも軽く紹介

<https://haskell.jp/blog/posts/2017/typesafe-precure2.html>

# cure-index.json とは？

- 「タイプセーフプリキュア！」本体は~~実用性を度外視して~~「設定の正しさ」を最優先事項とした結果、非常に冗長な記述が必要に。
- 集めた情報を有効活用するためJSONとして吐き出すことに。
    - [かつてrubicureで作ったユナイトプリキュア](http://the.igreque.info/posts/2014-12-25-unite-precure.vim.html)を書き直すのがゴール

# 修正前のcure-index.jsonの問題点

- 「HUGっと！プリキュア」と「キラキラ☆プリキュアアラモード」の情報しか収録されていない。
- 収録のためにはプリキュアの設定の書式を大幅に変更しなければならず、  
  面倒なので新しく追加されたシリーズしか対応しなかった。

# 🔴修正**前**の書式

[👇こんな感じのTypes.hsがたくさん](https://github.com/igrep/typesafe-precure/blob/73948fb4a82baaf4e33900d77326791c7703f786/src/ACME/PreCure/Textbook/MahoGirls/Types.hs#L71)

```haskell
data CureMiracle = CureMiracle deriving (Eq, Show)

transformedInstance
  [t| CureMiracle |]
  cureName_Miracle
  introducesHerselfAs_Miracle
  variation_Dia
```

# 🔴修正**前**の書式

[👇こんな感じのWords.hsがたくさん](https://github.com/igrep/typesafe-precure/blob/73948fb4a82baaf4e33900d77326791c7703f786/src/ACME/PreCure/Textbook/MahoGirls/Words.hs#L18)

```haskell
cureName_Miracle = "キュアミラクル"
introducesHerselfAs_Miracle = "ふたりの奇跡！キュアミラクル！"
variation_Dia = "ダイヤスタイル"
```

# 🔴修正**前**の書式

- プリキュアや変身アイテムなど、それぞれの型を手で定義
- それぞれの型に対してTemplate Haskellという  
  「劣化版Lispのマクロのみたいな機能」を使って  
  型クラスのインスタンスを自動生成
    - 詳しくは[このあたり](https://qiita.com/igrep/items/5496fa405fae00b5a737#templatehaskell)を参照

# 🔴修正**前**の書式

- Template Haskellの機能的な制限上、台詞などの文字列を共通化して使い回したい場合、ファイルを分けなければならない
    - 別に`"キュアミラクル"`ぐらい使い回さんでもええやろ、って気もしますが、当時の私は狂ったように共通化してました😅
- あくまでもHaskellのソースコードとして書かれているため、このままではcure-index.jsonのデータとして扱うのがほぼ無理

# 🔵修正**後**の書式

[👇こんな感じのProfiles.hsがたくさん](https://github.com/igrep/typesafe-precure/blob/fd5f89797372f616a551e07251c0fcd2ca1531c2/src/ACME/PreCure/Textbook/MahoGirls/Profiles.hs#L20)  

```haskell
mkTransformee
  "Cure Miracle"
  ""
  cureName_Miracle
  variation_Dia
  introducesHerselfAs_Miracle
```

<small>※Words.hsについては面倒なので書き換えはせず</small>

# 🔵修正**後**の書式

[加えて👇こんな感じのファイルがたくさん](https://github.com/igrep/typesafe-precure/blob/fd5f89797372f616a551e07251c0fcd2ca1531c2/src/ACME/PreCure/Textbook/MahoGirls.hs#L16)  

```haskell
{-# ANN module transformees #-}
$(declareTransformees transformees)
```

- ☝️この2行で、
    - JSON向けのデータとしてプリキュアの情報を収集して、
    - JSON向けののデータから型と型クラスのインスタンス両方を自動生成

# 🔵修正**後**の書式

修正前との重要な違い:

- プリキュアの情報を、
    - cure-index.json として書き出すためのデータ
    - Template Haskellで型や型クラスのインスタンスとして生成するためのデータ
- **両方で扱えるようにするために、専用の型の値として保存する**

# どうやって修正する？

- 😫手で修正するのはしんどい
    - TVシリーズ15作品 - HUGプリ - プリアラ + オールスターズDX = 14作品分書き換えないと...
- 「タイプセーフプリキュア！」はこれまでGHCの拡張を始めいろいろな技術を試すための実験場だった
    - せっかくなんでなんか使ってパーッと書き換えたい！
    - 💡そうだ、パーサーコンビネーターだ！

# パーサーコンビネーターとは

- Haskell界に長年伝わる、文字列解析技術
    - ナシHaskell界でも実装したライブラリーはたくさんあるので、  
      探してみて欲しいな！
    - Rubyだと`StringScanner`を使うと割と近いものができるよ！
- 文字列を受け取って
    - 「文字列を変換した結果」と、
    - 「残りの文字列」
    - を返す関数
- 組み合わせることでより複雑な文字列から複雑なデータ構造を取り出せる

# パーサーコンビネーターの例

おことわり hask(\_ \_)eller

- ※次に紹介するパーサーコンビネーターは、  
  実際のパーサーコンビネーターのライブラリーを、  
  説明のために大幅に簡略化させたものです。

# パーサーコンビネーターの例

10進数の文字列を受け取って、整数を返すパーサー

```haskell
> parse digits "123abc"
(123, "abc")
```

- パースした結果`123`と、残りの文字列`"abc"`を返す

# パーサーコンビネーターの例

文字 カンマ `,` を受け取って、そのまま返すパーサー

```haskell
> parse (char ',') ",aaa"
(',' , "aaa")
```

# パーサーコンビネーターの例

以上を組み合わせて、  
**10進数の文字列を受け取った後、カンマを受け取り、整数を返すパーサー**  
を作る

```haskell
> digitsAndComma = do
    n <- digits
    char ','
    return n
> parse digistsAndComma "123,abc"
(123, "abc") -- 結果にカンマが含まれてない点に注意
```


# パーサーコンビネーターの例

`many`を使って、  
**10進数の文字列を受け取った後、カンマを受け取り、整数を返すパーサー**  
から、  
**カンマで区切られたたくさんの整数のリストを返すパーサー**  
を作る

```haskell
parse (many digistsAndComma) "12,34,56,"
([12, 34, 56], "")
```

# 👍パーサーコンビネーターが正規表現より良いところ

- 👍パーツとしてパーサーを組み合わせるのが簡単
    - 複雑なパーサーも、小さなパーサーの組み合わせからコツコツと作れる
- 👍パースした結果を、文字列から複雑なデータ構造に割り当てるのが簡単
    - さっきの`digits`は、パースした結果を直接整数(`Int`)として返している
    - 再帰的なパーサーを書いて再帰的なデータ構造に割り当てるのも楽勝！

# 👎パーサーコンビネーターが正規表現より悪いところ

- 👎記述が冗長
    - 👍その分、記号よりも覚えやすい関数を組み合わせて書ける
- 👎言語内DSLなので、ユーザーからの入力として直接受け取ることはできない

# 👎パーサーコンビネーターが正規表現より悪いところ（続き）

- 👎正規表現でいうところの `*` にあたる`many`が、必ず強欲なマッチになる（後述）
- 👎**文字列の先頭からのマッチしかできない**
    - [substring-parser](https://gitlab.com/igrep/substring-parser)というライブラリーを書いて対応

# 👎先頭からのマッチしかできない

- 正規表現で例えると、常に`\A` (あるいは `^`)を着けなければならないイメージ
- そもそもの用途が0からプログラミング言語のパーサーを作るところにあるので、妥当と言えば妥当な制限

# 👎先頭からのマッチしかできない（続き）

- マッチさせたい文字列が「中間」にある場合、スキップするための処理を書かないといけない

# 👎先頭からのマッチしかできない（続き）

- 正規表現で言うところの `\A.*(マッチさせたい文字列)` を書けばよい話**ではなく**、  
  `\A(マッチさせたくない文字列)*(マッチさせたい文字列)` みたいに書かないといけない

# 👎先頭からのマッチしかできない（続き）

- 「正規表現でいうところの `*` にあたる`many`が強欲なマッチになる」ため、  
  `\A.*(マッチさせたい文字列)`と書くと、  
  `.*`が`(マッチさせたい文字列)`がマッチさせたい文字列まで飲み込んでしまう

# 今回の目的では

- ソースコードの**途中**に含まれている、プリキュアを表す型の定義や、型クラスのインスタンス宣言を集める
- 文字列の先頭から必ずマッチさせるのでは、ちょっとつらい

# そこで！

任意のパーサーコンビネーターを  
**文字列の中間でも**  
マッチするよう変換するライブラリーを作りました！

- [substring-parser](http://hackage.haskell.org/package/substring-parser)
    - 個人的な判官びいきにより[GitLabにおいております](http://gitlab.com/igrep/substring-parser)。
    - ドキュメント書けてない... 😥

# 基本的な仕組み

- 指定したパーサーを
    - とりあえず先頭からマッチさせてみる
    - 失敗したら先頭の一文字をスキップして、またマッチさせてみる
    - その繰り返し！
- ➡️結果として文字列の先頭にある`(マッチさせたくない文字列)`をスキップすることができる
    - ⚠️決して効率のいい方法ではないので、真面目なパーサーを書くときはおすすめしません！

# 結果、できたこと

[こちらのコミット時点のパーサー](https://github.com/igrep/typesafe-precure/blob/73948fb4a82baaf4e33900d77326791c7703f786/app/migrate2cure-index.hs#L101-L118)で、  
[同時点のTypes.hs](https://github.com/igrep/typesafe-precure/blob/73948fb4a82baaf4e33900d77326791c7703f786/src/ACME/PreCure/Textbook/Dokidoki/Types.hs#L19-L23)から、  
cure-indexで使用する[`Girl`](https://github.com/igrep/typesafe-precure/blob/73948fb4a82baaf4e33900d77326791c7703f786/src/ACME/PreCure/Index/Types.hs#L44-L46)という型の値を取り出します！

```
stack build :migrate2cure-index
stack exec migrate2cure-index
```

# 結果、できたこと

- 最終的に実行した移行用スクリプトはこちら
    - [typesafe-precure/app/migrate2cure-index.hs](https://github.com/igrep/typesafe-precure/blob/ed038aa57a4df6b1fcc23fb071253888ebd7d477/app/migrate2cure-index.hs)
- その後いろいろ手直しをしたPull requestはこちら
    - [typesafe-precure#25](https://github.com/igrep/typesafe-precure/pull/25)
    - [typesafe-precure#26](https://github.com/igrep/typesafe-precure/pull/26)


# 次のゴール

- cure-index.jsonを使って、「ユナイトプリキュア」を「ディナイトプリキュア」として書き直す？
- でももうちょっとHaskellで遊びたいことがあるので後回しにするかも？
    - Vim script書きたくない...

# まとめ

- Haskell界に伝わる伝説のアイテム「パーサーコンビネーター」を応用して、  
  「タイプセーフプリキュア！」の古いソースコードを半自動で変換しました
- 「パーサーコンビネーター」は正規表現よりいいところたくさんだけど、文字列の先頭からのマッチしかできないのがつらい
    - [substring-parser](https://gitlab.com/igrep/substring-parser)というライブラリーを書いて、対応しました
- パーサーコンビネーター最高！ ✌️😆✌️
