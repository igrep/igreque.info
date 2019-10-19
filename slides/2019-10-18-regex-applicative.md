% regex-applicative: 内部DSLとしての正規表現
% Yuji Yamamoto (山本悠滋)
% 2019-10-18 Regex Festa

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約7年。
- 趣味Haskeller兼仕事Haskeller @ [IIJ-II](https://www.iij-ii.co.jp/) 😁
- igrep.elというEmacsプラグインがありますが無関係です！

# 宣伝 hask(\_ \_)eller

- 2017年から[日本Haskellユーザーグループ](https://haskell.jp/)というコミュニティーグループを立ち上げ、その発起人の一人として活動しております。
    - 愛称: Haskell-jp
- [Slackのワークスペース](https://join.slack.com/t/haskell-jp/shared_invite/enQtNDY4Njc1MTA5MDQxLWY1ZDVhZjIzMGE1MDMzZDAyNGZmYTU5M2VlODg5NTNmY2QwNGU1NjJjMjYzN2VjZmRjMDNiNGU0NjI5NDdlMTc)や[Subreddit](https://www.reddit.com/r/haskell_jp/)、[ブログ](https://haskell.jp/)、[Wiki](http://wiki.haskell.jp/)など、いろいろ運営しております。

# 📝今日話すこと

- Haskell向け内部DSL、[regex-applicative](http://hackage.haskell.org/package/regex-applicative)パッケージの紹介
- regex-applicativeの仕組み
    - 継続渡しで作られたNFA
- 類似のライブラリーとの比較を軽く
    - 各種パーサーコンビネーター
    - VerbalExpressions

# 🙊今日話さないこと

- 出てくるHaskellの機能の詳細
    - Applicativeとか

# regex-applicativeって？

- 正規表現をHaskellの内部DSLとして表現したライブラリー
- 二項演算子をユーザーが定義できるHaskellの仕様により、なかなか変わった構文に
    - 実は`Applicative`や`Alternative`という型クラスのメソッドが中心なので慣れていればわかりやすい

# regex-applicativeの例(1)

マッチさせるのに使う関数（他にもある）

```haskell
match :: RE s a -> [s] -> Maybe a
```

- 正規表現オブジェクト `RE s a`型の値と、対象の文字列 `[s]`型の値を受け取ってマッチした結果を返す
    - 完全一致じゃないとマッチしないので注意

# regex-applicativeの例(1)

<!--
import Text.Regex.Applicative
import Text.Regex.Applicative.Common
-->

ただの文字: `sym`

```haskell
> match (sym 'a') "a"
Just 'a' -- 成功したら `Just ...` な値を返す

> match (sym 'a') "b"
Nothing  -- 失敗したら `Nothing` を返す
```

# regex-applicativeの例(2)

連接: `*>`・`string`

```haskell
> match (sym 'a' *> sym 'b') "ab"
Just 'b'

-- マッチする文字列は同じ、より分かりやすいバージョン
> match (string "ab") "ab"
Just "ab"
```

# regex-applicativeの例(3)

選択: `<|>`

```haskell
> match (sym 'a' <|> sym 'b') "a"
Just 'a'
> match (sym 'a' <|> sym 'b') "b"
Just 'b'
```

# regex-applicativeの例(4)

繰り返し: `many`・`some`

```haskell
> match (many (sym 'a')) "aaaaaaaaaa"
Just "aaaaaaaaaa"
```

- 0回以上が`many`、1回以上が`some`

# regex-applicativeの例(5)

オプショナルなマッチ: `optional`

```haskell
> match (sym 'a' *> optional (sym 'b')) "ab"
Just (Just 'b')
> match (sym 'a' *> optional (sym 'b')) "a"
Just Nothing
```

# regex-applicativeの例(6)

マッチした結果をHaskellの値に割り当て

```haskell
> match digit "1"
Just 1 -- マッチした結果が整数として返ってくる！
> match (many digit) "12345"
Just [1,2,3,4,5] -- マッチした結果が整数のリストに！
```

# regex-applicativeの例(7)

マッチした結果をHaskellの値に割り当て、さらに計算！

```haskell
> match (sum <$> many digit) "12345"
Just 15
```

- `<$>`: 左辺に渡した関数を、右辺に渡した正規表現でマッチした結果に渡す

# regex-applicativeの例(7)

もうちょっと複雑な例: まずは部品作り

```haskell
> schemeRe = ((++) <$> string "http" <*> (string "s" <|> pure "")) <* string "://"
```

- マッチ結果を`<$>`や`<*>`で`Origin`関数一つ一つの引数に割り当てる
- `<|>`と`pure`を使うとマッチに失敗した場合のデフォルト値を指定できる
    - `pure`: 空文字列にしかマッチしないけど値は返す正規表現を作る

# regex-applicativeの例(7)

もうちょっと複雑な例: まずは部品作り（続き）

```haskell
> hostRe = some (psym (`elem` ['a'..'z'] ++ "."))
> portRe = sym ':' *> decimal
```

# regex-applicativeの例(7) (続き)

もうちょっと複雑な例: 結合させる

```haskell
> originRe = schemeRe *> hostRe *> optional portRe
```

# regex-applicativeの例(7) (続き)

もうちょっと複雑な例: 使ってみる

```haskell
> match originRe "https://example.com:8080"
Just (Just 8080) -- マッチが成功してポート番号がとれた
> match originRe "http://example.com"
Just Nothing     -- マッチは成功したけどポート番号はとれなかった
```

# regex-applicativeの例(8)

マッチ結果の構造体への割り当て: まずは構造体の定義

```haskell
data Origin =
  Origin { scheme :: String, host :: String, port :: Int }
  deriving Show
```

# regex-applicativeの例(8) (続き)

```haskell
originRe = Origin   <$>
           schemeRe <*>
           hostRe   <*>
           (portRe <|> pure 80)
```

# regex-applicativeの例(8) (続き)

```haskell
> match originRe "https://example.com:8080"
Just (Origin {scheme = "https", host = "example.com", port = 8080})
> match originRe "http://example.com"
Just (Origin {scheme = "http", host = "example.com", port = 80})
```

# 👍regex-applicativeのメリット

- 内部DSLとして書けるので、コンパイラーによる型チェックの恩恵を受けやすい
- 文字列以外の扱いにも強い
    - マッチした結果から（文字列以外の）Haskellの値に割り当てるのが簡単！
        - 「生のデータ」から「コアの処理が欲しいデータ」への変換がワンストップ
    - 文字列だけでなく、任意のリストに対してマッチできる

# 👎regex-applicativeのデメリット

- コードは長い
- 速度はおそらくCとかで書いたものほど速くはない
    - そんなに細かい最適化をしているわけではないし、Pure Haskellなので...
- Haskellの`String`以外の文字列にはマッチできない...
    - 参考: [Haskell Tips (文字列編) - りんごがでている](http://bicycle1885.hatenablog.com/entry/2012/12/24/234707)

# ⚙️regex-applicativeの仕組み

- 継続渡しで作られたNFA
- バックトラックするときは継続を切り替える

# 📑正規表現エンジンの分類

※[正規表現技術入門](https://gihyo.jp/book/2015/978-4-7741-7270-5) p. 56より

- DFA型
    - 正規表現を決定性有限オートマトン（deterministic finite automaton）と呼ばれるものに変換して正規表現マッチングを行う
- VM型
    - 正規表現をバイトコード（bytecode）と呼ばれるものに変換して正規表現マッチングを行う

# regex-applicativeの場合は...？

😕どちらでもなさそう？

- NFAをDFAに変えずにそのまま使っている
- NFAにおける状態遷移を「文字を受け取って次の状態のリストを返す関数」で表す

# regex-applicativeの実際の実装

- [`compile`](https://github.com/feuerbach/regex-applicative/blob/5e9a06622d33c7657353ddaccfe101b96946027a/Text/Regex/Applicative/Object.hs#L110-L111)という関数で、正規表現オブジェクト`RE s a`を[`ReObject`](https://github.com/feuerbach/regex-applicative/blob/5e9a06622d33c7657353ddaccfe101b96946027a/Text/Regex/Applicative/Object.hs#L38-L43)という、[`Thread`](https://github.com/feuerbach/regex-applicative/blob/5e9a06622d33c7657353ddaccfe101b96946027a/Text/Regex/Applicative/Types.hs#L9-L16)オブジェクトのキューに変換する
- `Thread`は👇の二通りの値をとりうる型
    - ⏩`s -> [Thread s r]`: 文字を受け取って次に分岐しうる`Thread`のリストを返す関数。文字が条件にマッチしなければ空リストを返して次に進まない
    - ✅`Accept r`: 文字どおり受理状態を表す
    - ⚠️並行並列プログラミングで出てくるあの「スレッド」とは違うので注意！

# regex-applicativeの実際の実装（続き）

- ➡️ `s -> [Thread s r]`の実行が成功したとき
    - 返却された`[Thread s r]`の要素をすべてキューに追加して、引き続き実行する
- ↩️ `s -> [Thread s r]`の実行が失敗したとき
    - バックトラック: 次に実行する`Thread`に切り替える
- ℹ️ 実際には`Thread`を一つずつ実行してみて、結果が条件に合うものを選ぶ、といった方が近い
    - `findLongestPrefix`関数などはそうした処理特性によって実現

# 類似のライブラリーとの比較を軽く

- 各種パーサーコンビネーター
- VerbalExpressions

# 各種パーサーコンビネーター

- Haskell向けのパーサーコンビネーターの多くは`Applicative`ベースのAPIなので、ぱっと見よく似てる
    - 場合によっては使うライブラリーだけ換えて式をコピペしてもコンパイルは通る（かも）
- バックトラックするかしないか
- regex-applicativeの方が部分文字列へのマッチが簡単
    - パーサーコンビネーターを、部分文字列のマッチに使いやすくするライブラリーもあるにはある
        - [replace-attoparsec](https://github.com/jamesdbrock/replace-attoparsec)

# VerbalExpressions

- 詳細わかりませんが作りはよく似てる
    - [JavaScriptの例がこちら](https://github.com/VerbalExpressions/JSVerbalExpressions#examples)
- 変な記号の演算子ではなく英語でつけられた関数なので、こちらの方が分かりやすいという人は多そう
- [Haskellを含むいろんな言語で提供されてるらしい](https://github.com/VerbalExpressions)
- さっと[Haskell版のドキュメント](http://hackage.haskell.org/package/verbalexpressions-1.0.0.0/docs/Text-Regex-VerbalExpressions.html)読んだ感じ、文字列のマッチに特化してるっぽい？

# まとめ

- regex-applicativeは、Haskellの式で正規表現を書ける内部DSL
- パーサーコンビネーターっぽく使えて、かつ正規表現の良さを持ち合わせている
- 内部は「文字を受け取って続きの状態のリストを返す関数」として表現されたNFAで実装されている
