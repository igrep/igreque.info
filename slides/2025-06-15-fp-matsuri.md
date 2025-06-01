---
title: 「Haskellは純粋関数型言語だから副作用がない」っていうの、そろそろ止めにしませんか？
author: YAMAMOTO Yuji (山本悠滋)
date:  2025-06-15 関数型まつり 2025

---

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
    - HN: すがすがC言語
- Haskeller歴 ≒ プリキュアおじさん歴 ≒ 約13年。
- 趣味ではTypeScriptで自作言語を作ったり、
- 仕事では[MagicPod](https://magicpod.com/)というアプリケーションを開発したりしています。
- igrep.elというEmacsプラグインがありますが無関係です！

# 🇯🇵自己紹介 + 宣伝 1:

- [日本Haskellユーザーグループ（Haskell-jp）](https://haskell.jp/)の発起人の一人です
- [haskell.jp](https://haskell.jp/)というドメインを活かして何かしら活動する人を応援します

# 🔰自己紹介 + 宣伝 2:

- そのHaskell-jpの活動の一環として、[Make Mistakes to Learn Haskell - 失敗しながら学ぶHaskell入門](https://github.com/haskell-jp/makeMistakesToLearnHaskell/)という入門コンテンツをずっと作っています
- 本文はおおよそ書けていて、今は細かいところを修正したりしています

# 📝今日話すこと

- Haksellは普通に入出力（IO）も出来る
    - 少なくともIOする時の開発体験は他の言語とあまり変わらない
- 本当に大事なこと:
    - IOが原則全てファーストクラスオブジェクトで表現されること
    - その「IO」を実行する機能が隠蔽されていること
- 「普通にIO出来る」Haskellは、型で副作用の有無を見分けられる
    - 「純粋」な部分と「不純」な部分を明確に分けることができる

# ⚠️おことわり

- 随所にHaskell（あるいは類似の言語）のソースコードが出てきますが、重要なポイントを必ず後で補足します
    - 「分からん！」という方はソースコードはうまくスルーしてください
        - Haskellをある程度書いたことがある人でさえあまり使ったことがないであろう構文も出てきます
    - 途中の解説も分からない場合、最後の「まとめ」だけ覚えてください
        - 詳しくは実際にHaskellを学んでください！

# どうして「純粋」なのか

- 👼Haskellは「純粋関数型言語」として生まれた
- 📜まずはその歴史を見てみよう

# Haskell が生まれた背景

- Haskell登場前:
    - ML, Miranda, Hopeなどの純粋関数型言語が登場
- 1987年: 純粋な関数型言語を統一しよう
    - ➡️Haskell Committee設立

# Haskell  以前の IO

Haskell以前における純粋関数型言語の代表、[Miranda最新版(2020年リリース‼️)](https://www.cs.kent.ac.uk/people/staff/dat/miranda/downloads/)の[マニュアル](https://www.cs.kent.ac.uk/people/staff/dat/miranda/manual/31/1.html)曰く...

- Mirandaには限られたIOしかない
    - `read :: [char]->[char]`など
        - ファイル名を受け取ってその中身を返す関数
    - 原則読むだけ！参照透明ですらない！
- ➡️「純粋関数型言語」という看板を下ろさないでIOしよう！
    - 重要なゴールだった模様

# Haskell 1.0 - 1.2 の IO (1)

[Report on the Programming Language Haskell Version 1.0](https://github.com/typeclasses/haskell-report-archive/blob/master/1990-04-haskell-1.0/haskell-report-1.0.pdf)より:

> Haskell's I/O system is based on the view that a program communicates to the outside
world via streams of messages:

```haskell
type Dialogue = [Response] -> [Request]
```

# Haskell 1.0 - 1.2 の IO (2)

[Report on the Programming Language Haskell Version 1.0](https://github.com/typeclasses/haskell-report-archive/blob/master/1990-04-haskell-1.0/haskell-report-1.0.pdf)より:

`Response`のリスト（ストリーム）を受け取って、`Request`のリスト（ストリーム）を返す関数

```haskell
type Dialogue = [Response] -> [Request]
```

- ➡️`Request`: 外の世界に送る命令
- ⬅️`Response`: 外の世界から渡される`Request`の結果

# Haskell 1.0 - 1.2 の IO (3)

- 🙃関数が**返した**`Request`に応じて**引数**の`Response`が変わるという、直感に反する挙動
    - 遅延リスト故に出来る仕組み（詳しくは省略！）
- 😮あくまで「外から来た`Response`を受け取って`Request`を返す」だけの純粋な関数に収まっている
    - 純粋っぽい！

# Haskell 1.0 - 1.2 の IO (4)

```haskell
data Request =
    ReadFile String
  | WriteFile String String
  | ReadChan String
  | AppendChan String String
  | GetEnv String
  | SetEnv String String
  | ...

data Response =
    Success
  | Str String
  | Failure IOError
  | ...
```

# Haskell 1.0 - 1.2 の IO (5)

- 💁ここから`Dialogue`を使ったプログラムの例を紹介します
- ⚠️何が書いてあるか分からなくても、とにかく「使いにくかった」ということだけ伝われば幸いです  
  hask(\_ \_)eller

# Haskell 1.0 - 1.2 の IO (6)

`Dialogue`を使って書いたコードの例  
　  

<img src="/imgs/2025-06-15-fp-matsuri-dialogue.png" alt="ソースコードを画像化したもの。元のソースコードは https://github.com/igrep/igreque.info/blob/master/slides/2025-06-15-fp-matsuri.md?plain=1#L133-L143 周辺を参照" style="width: 100%; max-width: 1168px; height: auto;" />

<!--
```haskell
main ~(Success : ~((Str userInput) : ~(Success : ~(r : _)))) =
  [ AppendChan stdout "please type a filename\n",
    ReadChan stdin,
    AppendChan stdout name,
    ReadFile name,
    AppendChan
      stdout
      (case r of Str
        contents -> contents
        Failure ioError -> "can't open file")
  ] where (name : _) = lines userInput
```
-->

# Haskell 1.0 - 1.2 の IO (7)


😩引数でパターンマッチした種類の`Response`と、対応する`Request`の順番が一致してないとダメ！

<img src="/imgs/2025-06-15-fp-matsuri-dialogue-annotated.png" alt="前のソースコードを画像化してResponseとRequestの対応関係が分かるよう矢印を付けたもの。" style="width: 100%; max-width: 1168px; height: auto;" />

# Haskell 1.0 - 1.2 の IO (8)

⏩使いにくいので継続渡しベースのラッパーが

```haskell
readFile name
  (\msg -> errorTransaction)
  (\contents -> successTransaction)
```

# Haskell 1.0 - 1.2 の IO (9)

⏩継続渡しって？

- 直接結果を返す代わりに、
- 「結果を受け取る関数」（継続）を引数として受け取り、
- 結果をその継続に渡す

# Haskell 1.0 - 1.2 の IO (10)

⏩継続渡しって？

比較的身近な例: JavaScriptのコールバックを受け取る関数

```js
// Node.jsのfsモジュール
readFile('file.txt', (err, data) => {
  console.log(data);
});
```

```js
// Promiseも立派な継続渡し
// then メソッドが継続を受け取る
readFile(filePath).then((contents) => {
  console.log(contents);
});
```

# Haskell 1.0 - 1.2 の IO (11)

⏩継続渡しって？

```ts
// 架空の、継続渡しじゃない普通の関数（構文はTypeScript）
readFile(path: string): string;

// その継続渡しバージョン
readFile<R>(path: string, k: (contents: string) => R): R;
```

# Haskell 1.0 - 1.2 の IO (12)

先程のプログラムをcontinuation basedで書き換えたもの

```haskell
main =
  appendChan stdout "please type a filename\n" exit (
    readChan stdin exit (\userInput ->
      let (name : _) = lines userInput in
        appendChan stdout name exit (
          readFile name
            (\ioError ->
              appendChan stdout
              "can't open file" exit done)
            (\contents ->
              appendChan stdout contents exit done))))
```

- 中で作っているのはあくまで`[Response] -> [Request]`な関数

# Haskell 1.3以降の IO (1)

[Report on the Programming Language Haskell Version 1.3](https://github.com/typeclasses/haskell-report-archive/blob/master/1996-05-haskell-1.3/haskell-report.pdf)より:

> The I/O system in Haskell is purely functional, yet has all of the expressive power found in
> conventional programming languages. To achieve this, Haskell uses a monad to integrate
> I/O operations into a purely functional context.

- 遂にモナドが！
    - ➡️今と一緒
    - モナドについての解説は割愛します hask(\_ \_)eller
- `Dialogue`型はなくなり、代わりに`IO`という型が登場

# Haskell 1.3以降の IO (2)

先程のプログラムを現代のHaskellに（ほぼ）直訳したもの

```haskell
main = do
  putStrLn "please type a filename\n"
  userInput <- hGetContents stdin
  let (name : _) = lines userInput
  putStrLn name
  contents <- readFile name
  putStrLn contents
```

- モナドなので`do`ブロックの中で利用できる
    - 詳細は割愛！

# `IO` は純粋な関数？

- 先に結論: 実用上は全くそんなことない！
    - 先ほどの例の通り！
- （モナドなので）複数の `IO` を列挙する際 `do` ブロックで囲う必要があったり、結果を代入するのに左細い矢印 `<-` を使うこと以外は概ね他の言語のIOと同じように使える

# `IO`の正体: それでも純粋っぽい部分 (1)

- `IO`は常にファーストクラスオブジェクト
    - 関数の引数や戻り値として使ったり、
    - 変数に代入したりできる
- 👇️こんな感じの型（[実際の定義](https://hackage.haskell.org/package/ghc-prim-0.13.0/docs/src/GHC.Types.html#IO)より単純化しています）  
  ```haskell
  newtype IO a = IO (RealWorld -> (RealWorld, a))
  ```

# `IO`の正体: それでも純粋っぽい部分 (2)

- `World`を受け取って`World`（と結果となる値）を返す**関数**をラップしたオブジェクト
- ただし！**直接実行する機能がない**。普通の関数のように**呼び出すことができない**
  ```haskell
  -- こんな風に書いてもエラーになる！
  let userInput = getLine()
  ```

# `IO`の正体: それでも純粋っぽい部分 (3)

- 🤔実行する仕組みがないなら、どうしてるの？
- 繋げる演算子ならある
- `>>=`
    - 通称「`bind`」
    - 両辺に`IO`と`IO`を返す関数を渡すと、それぞれを繋げた新しい`IO`ができる

# `IO`の正体: それでも純粋っぽい部分 (4)

- ➡️あくまで`IO`を繋げて「組み立てる」だけ
    - 実行はしない！
    - `IO`を繋げた結果もまた`IO`になるので、  
      **`IO`を使っている箇所はみんな`IO`型の関数になる**

# `>>=`の例1: `IO`同士を繋げる

```haskell
getLine >>= (\line -> putStrLn line)
```

`do`記法で分かりやすくしたバージョン:

```haskell
do
  line <- getLine
  putStrLn line
```

やっぱりこれはダメ:

```haskell
do
  let line = getLine()
  putStrLn line
```

# `>>=`の例2: 純粋な関数の中から`IO`を呼んで`IO`にする (1)

純粋な関数

```haskell
addOne :: Int -> Int
addOne x = x + 1
```

# `>>=`の例2: 純粋な関数の中から`IO`を呼んで`IO`にする (2)

その中で`IO`を呼ぶ

```haskell
addOne :: Int -> IO Int
addOne x = print x >>= (\_unused -> return (x + 1))
```

# `>>=`の例2: 純粋な関数の中から`IO`を呼んで`IO`にする (3)

`do`記法で分かりやすくしたバージョン:

```haskell
addOne :: Int -> IO Int
addOne x = do
  print x
  return (x + 1)
```

# `IO`を繋げて「組み立てる」だけ？ (1)

それを言ったら、他の言語も「命令を列挙している」だけでは？

```js
// JavaScript風の擬似コード
function main() {
  print("please type a filename");
  const userInput = getInput();
  const name = userInput.split("\n")[0];
  print(name);
  const contents = readFile(name);
  print(contents);
}
```

# `IO`を繋げて「組み立てる」だけ？ (2)

- `>>=`で繋げた`IO`も、結局はコンパイラーなどを通じて実行する（副作用を起こす）プログラムになる
- 何より、`IO`の実際の使用するときの体験は他のプログラミング言語で入出力をするときとほぼ同じ
- `<-`を使う、など構文の細かい違いがあったり、
- 「`IO`は常にファーストクラスオブジェクト」なのでその分少し機能が多いが...
    - （🙇詳しくは割愛！）

# 想定反論: こういう意見もある

- [🤔「視点の違いでは？」](https://kazu-yamamoto.hatenablog.jp/entry/20090627/1246135829)
    - 一言で言うと: 「評価器までがHaskell」、「実行器までがHaskell」などの立場があり、それによって「Haskellに副作用があるかないか」の結論が変わる
- ➡️ほとんどのプログラマーにとっては「実行器までがHaskell」。他の言語ではそんな議論するまでもない
    - いずれにしても、`IO`の実際の使用するときの体験はは他のプログラミング言語で入出力をするときとほぼ同じ

# 何故こんな議論に？

- Haskellが純粋じゃないと、アイデンティティーの危機が！
    - 「純粋関数型言語」と呼べなくなる！
    - 「Haskellを純粋関数型言語にしよう」という動機で作ったはずが  
      「Haskellだから純粋関数型言語ということにしよう」という逆の動機が働いてないか？
- 実際のHaskellは`IO`を実行できるし、
    - その`IO`はファーストクラスオブジェクトであり、
    - `IO`を実行する箇所とそうでない箇所をマークして区別できる言語

# まとめ

- Haksellは普通に入出力（IO）も出来る
    - 少なくともIOする時の開発体験は他の言語とあまり変わらない
        - ➡️「純粋関数型言語」であることが目的化していたのでは？
        - ➡️IOを使うときは普通に命令型で考えよう
- 本当に大事なこと:
    - IOが原則全てファーストクラスオブジェクトで表現されること
    - その「IO」を実行する機能が隠蔽されていること
        - ➡️結果として「純粋」な部分と「不純」な部分を明確に分けることができる


<!--

概要: 「Haskellは純粋関数型言語だから副作用がないらしいけど、入出力処理などはどうやるんだろう？」というような疑問を抱えている方は多いでしょう。本発表ではHaskellの歴史と現状を顧みて、そのような疑問が生まれる背景や、「Haskellは副作用がない」と考えることの問題点と、それを踏まえて「副作用があるHaskell」という認識が普及した未来について論じます。関数型プログラミングやHaskellを学習する際ありがちな「思考の憑きもの」を祓う発表になれば幸いです。

話したいこと案（TBD）

- 昔は確かに「純粋」だった（あるいは純粋を目指していた）
    - それらしい部分はIOによって完全に隠蔽され、よく知らないと区別できなくなった
- 関数型パーサーとかも純粋な関数ではあるが結局命令型プログラミングらしくなる（「純粋」というより「命令型をうまい具合に取り入れた」？）
    - 本当に大事なこと1: 「純粋」から「不純」へのグラデーションが描けるようになった（Effect Systemの話とかに繋げる？）
- どうして「純粋」だと言い張れるのか
    - 本当に大事なこと2: IOが原則全てファーストクラスオブジェクトであること
    - Identity crisis との闘い: ではHaskellは何なのか
- 純粋な関数と関数型プログラミングの限界を認めて楽になろう

https://dl.acm.org/doi/10.1145/1238844.1238856

https://www.haskell.org/onlinereport/haskell2010/haskellli2.html#x3-2000

https://en.wikipedia.org/w/index.php?title=Haskell&oldid=1281033176

https://ja.wikipedia.org/w/index.php?title=Miranda&oldid=93111387

https://www.cs.kent.ac.uk/people/staff/dat/miranda/downloads/

https://github.com/typeclasses/haskell-report-archive

https://www.cs.kent.ac.uk/people/staff/dat/miranda/

https://www.cs.kent.ac.uk/people/staff/dat/miranda/manual/100.html

https://ja.wikipedia.org/wiki/%E7%B6%99%E7%B6%9A%E6%B8%A1%E3%81%97%E3%82%B9%E3%82%BF%E3%82%A4%E3%83%AB

> 継続渡しスタイルで書かれた関数は、通常の直接スタイル (direct style) のように値を「返す」かわりに、「継続」を引数として陽に受け取り、その継続に計算結果を渡す。

https://nodejs.org/api/fs.html#fsreadfilepath-options-callback

https://en-ambi.com/itcontents/entry/2017/08/25/110000#main%E3%81%A8IO%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E7%B0%A1%E5%8D%98%E3%81%AB

# おまけ: `IO`以外にも...

パーサーコンビネーターを例に`State`モナドなどの話をしたかったが、初心者向けには難しそうなので割愛
-->
