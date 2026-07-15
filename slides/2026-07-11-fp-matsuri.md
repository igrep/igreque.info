---
title: モナドっていうほど関数型プログラミング関係なさそうだよな
author: YAMAMOTO Yuji (山本悠滋)
date:  2026-07-11 関数型まつり 2026

---

# はじめまして！ 👋😄

- [山本悠滋](https://github.com/igrep) ([\@igrep](https://github.com/igrep))
- Haskeller歴 ≒ プリキュアおじさん歴 ≒ 約14年。
- 趣味ではTypeScriptで自作言語を作ったり、
- 仕事では[MagicPod](https://magicpod.com/)というアプリケーションを開発したりしています。

# はじめまして！ 👋😄

- igrep.elというEmacsプラグインがありますが無関係です！
- 先日は「igrep-tme」というパッケージの作者と勘違いされてメールを頂きましたが、知りません！
    - ![](/imgs/2026-07-fp-matsuri/igrep-tme.png)

# 🇯🇵自己紹介 + 宣伝 1: Haskell-jp

- [日本Haskellユーザーグループ（Haskell-jp）](https://haskell.jp/)の発起人の一人です
- [haskell.jp](https://haskell.jp/)というドメインを活かして何かしら活動する人を応援します

# 🔰自己紹介 + 宣伝 2: Haskell入門コンテンツ

- そのHaskell-jpの活動の一環として、[Make Mistakes to Learn Haskell - 失敗しながら学ぶHaskell入門](https://github.com/haskell-jp/makeMistakesToLearnHaskell/)という入門コンテンツをずっと作っています
- 本文は書けていて、今はウェブアプリケーションとして利用できるよう開発しています

# 🟢自己紹介 + 宣伝 3: 私とモナド

Haskellを学んで以来、度々Haskellのモナドを解説してきました:

- [「やらなければならないこと」としてのHaskellのMonad](/slides/2014-05-11-monad-as-have-to-do.html)
    - 2014年5月 関数型LT大会
- [Monadなんてどうってことなかった話](/slides/2015-03-21-monad-foundation.html)
    - 2015年3月 モナド基礎勉強会
- [JavaでMonadをはじめからていねいに :: Igreque -> Info](https://the.igreque.info/posts/2016/04-monad-in-java.html)
- [Writer Monadで気軽にMonad則を破る - Haskell-jp](https://haskell.jp/blog/posts/2020/break-monad-law-with-writer.html)
    - [「モナド則を崩してしまう例が知りたい」という質問](https://ja.stackoverflow.com/questions/70079/%E3%83%A2%E3%83%8A%E3%83%89%E5%89%87%E3%82%92%E5%B4%A9%E3%81%97%E3%81%A6%E3%81%97%E3%81%BE%E3%81%86%E4%BE%8B%E3%81%8C%E7%9F%A5%E3%82%8A%E3%81%9F%E3%81%84)への回答のついで

# 📝今日のゴール

- 関数型言語<small>（というかHaskellとその類似の言語）</small>におけるモナドの**役割**を明らかにする
    - モナドの技術的な**中身**の解説はしません
- それを通じて、関数型プログラミングとは何なのか、明確なイメージを持ってもらう

# ⚠️おことわり

- 登場するサンプルコードは全て JavaScript **風**の疑似言語で書かれています
    - 特に JavaScript 固有の話はありません
    - JavaScript にない関数・構文が登場することもあります

# 関数型プログラミングとは

純粋な関数を中心としたプログラミングだ  
<small>（本発表における定義）</small>

# 純粋な関数とは

引数（入力）が同じであれば、常に同じ結果（出力）を返す関数

- ➡️ 引数からしか影響を受けないし、結果を返す以外に外部へ影響を与えない

# 純粋な関数とは

![](/imgs/2026-07-fp-matsuri/pure-function.svg)

# 純粋な関数とは

```js
y = f(x)
```

- 例えば上記👆の式があったとき、`f` が純粋な関数であれば、
    - 引数 `x` が同じであれば、必ず同じ結果を `y` に代入する
    - `f` は `x` 以外のどこからも影響を受けない
    - `f` は `y` 以外のどこにも影響を与えない

# 純粋な関数だとやりやすいこと

- 関数がどこに影響を与えるかを見極める
- 関数の振る舞いをテストしたり、証明したりする
    - いわゆる単体テストが簡単
    - Lean とか Rocq とか Agda とかが扱えるのも純粋な関数だから
- 式を評価する順番を変える
    - 遅延評価など

# 純粋な関数だとやりづらい、というかできないこと

- 普通の関数ならできたことの多く
    - 結果を戻り値として返す以外で表現する（副作用）
    - 異常系の結果をまとめて処理する（例外処理）

# 結果を戻り値として返す以外で表現する（副作用）

普通の関数: 引数の一部を直接書き換える

```js
function setNAtZero(array, n) {
  result = array[0];
  array[0] = n;
  return result;
}
```

# 結果を戻り値として返す以外で表現する（副作用）

普通の関数: 引数の一部を直接書き換える

```js
array  = [1, 2, 3];
result = setNAtZero(array, 9);
=> array  = [9, 2, 3]
=> result = 1
```

# 結果を戻り値として返す以外で表現する（副作用）

普通の関数: 引数の一部を直接書き換える

```js
array  = [1, 2, 3];
result = setNAtZero(array, n);
// 👆だけじゃなく、   👆
//                  👆
//                  👆にも影響を与えてる！！
```

- ↕️ 二つの箇所に影響を与えている！！

# 結果を戻り値として返す以外で表現する（副作用）

純粋な関数で似たようなことをするには？

- 📂複数の値を含むことができる値（例: タプル）でくるんで返す

```js
function setNAtZeroPure(array, n) {
  result = array[0];
  // set: 指定したインデックスの値を
  //      置き換えたバージョンの配列を返す関数。
  //      元の配列は書き換えない。
  newArray = set(array, 0, n);
  return [newArray, result];
}
```

# 結果を戻り値として返す以外で表現する（副作用）

使用例

```js
array0  = [1, 2, 3];
[array1, result1] = setNAtZeroPure(array0, 0);
[array2, result2] = setNAtZeroPure(array1, 1);
[array3, result3] = setNAtZeroPure(array2, 2);
```

- ちょっと面倒くさい😥

# 異常系の結果をまとめて処理する（例外処理）

普通の関数: 例外を投げることで、一箇所の`catch`で処理する

```js
function getAt(array, n) {
  if (n < 0 || n >= array.length) {
    throw Error("Index out of bounds");
  }
  return array[n];
}
```

# 異常系の結果をまとめて処理する（例外処理）

使用例:

```js
try {
  result1 = getAt(array, 1);
  result2 = getAt(array, 2);
  result3 = getAt(array, 3);
} catch (e) {
  console.log("Error: " + e.message);
}
```

# 異常系の結果をまとめて処理する（例外処理）

🙅‍♀️`getAt`は純粋？

```js
try {
  result1 = getAt(array, 1);
  // 👆 result1 だけじゃなく...
  // ...
} catch (e) {
  // 👆 e にも影響を与えうる！
  console.log("Error: " + e.message);
}
```

# 異常系の結果をまとめて処理する（例外処理）

純粋な関数で似たようなことをするには？

- 🔙 例外を戻り値として返す

```js
function getAt(array, n) {
  if (n < 0 || n >= array.length) {
    return Error("Index out of bounds");
  }
  return array[n];
}
```

# 異常系の結果をまとめて処理する（例外処理）

使用例

```js
result1 = getAt(array, 1);
if (result1 instanceof Error) {
  console.log("Error: " + result1.message);
} else {
  result2 = getAt(array, 2);
  if (result2 instanceof Error) {
    console.log("Error: " + result2.message);
  } else {
    // ...
  }
}
```

- 結果を毎回確認しなければならず、やっぱり面倒くさい😥

# ここまでのまとめ

純粋な関数は、その制約により、

- 関数がどこに影響を与えるかを見極め安いなどの利点がある一方、
- 普通の関数よりやりづらいこともある。

# モナドとは

⚠️ あくまでもプログラミングの文脈での「モナド」の話です。  
⚠️ 以下は定義ではありません。詳細は割愛します。Haskell などを学ぼう！

- 純粋な関数の制限をいい感じに緩和してくれるすごい機能
- 時間的な順番が重要な計算を始めとする、「命令」っぽい処理を組み立てるためのインターフェイス

# モナドがもたらすもの

- 純粋な関数にある制限の、いい感じな緩和！
- 一定のルールに従う関数<small>（正確には値）</small>を、<small>（Haskellなどでは）</small>`do`という構文を使って簡単に組み合わせられるようにする
- 💁「一定のルールに従う関数」を本発表では「命令」と呼びます
    - 副作用を伴う関数や例外処理が必要な関数も「命令」として扱える
    - モナドの種類によって、「命令」の機能はバラバラ

# 実例、その前に

これまで使ってきた疑似言語に`do`構文を導入します:

```js
do {
  y <- f(x);
  a <- g(y, z);
  return a;
}
```

# 実例、その前に

これまで使ってきた疑似言語に `do` 構文を導入します:

- `do { ... }`:
    - あるモナドが有効な範囲を区切る
- `result <- f(x)`:
    - `f(x)` を「命令」の実行として処理して、結果を `result` に代入する
    - `do` の中で「命令」を複数列挙すると、組み合わせることができる
- `return a`:
    - `do` で組み合わせて作った「命令」の結果として、`a` を返す
- 実はHaskellなどでも似たような構文が使える

# `State` モナドで「結果を戻り値として返す以外で表現する」

👇以下のような関数は、`State` モナドの「命令」として使える:

```js
function setNAtZeroPure(array, n) {
  //                    👆
  //                  arrayを受け取って
  result = array[0];
  newArray = set(array, n, 0);
  return [newArray, result];
  //      👆
  // またarray（引数と同じ型の値）をresultと一緒に返す
}
```

# `State` モナドで「結果を戻り値として返す以外で表現する」

再掲: 純粋な関数だと面倒な例

```js
array0  = [1, 2, 3];
[array1, result1] = setNAtZeroPure(array0, 0);
[array2, result2] = setNAtZeroPure(array1, 1);
[array3, result3] = setNAtZeroPure(array2, 2);
```

- 「普通の関数」で副作用が使える場合は、引数の `array0` などは直接書き換える
    - 書き換えた後の引数の値が欲しいから
- ➡️ `setNAtZeroPure` に渡した後は、`array0` などの値に関心がないはず

# `State` モナドで「結果を戻り値として返す以外で表現する」

<small>（`State` モナドにおける）</small>`do` 構文を使って書き換えると:

```js
operations = do {
  result1 <- setNAtZeroPure(0);
  result2 <- setNAtZeroPure(1);
  result3 <- setNAtZeroPure(2);
}
operations([1, 2, 3]);
```

# `State` モナドで「結果を戻り値として返す以外で表現する」

何が起きた？

```js
// Before
[array1, result1] = setNAtZeroPure(array0, 0);

// After
result1 <- setNAtZeroPure(0);
```

- 🫥 `array0` や `array1` などが消えた！

# `State` モナドで「結果を戻り値として返す以外で表現する」

`array0` はどこに行った？

```js
// Before
array0  = [1, 2, 3];

// After
operations = do { /* ... */ }
operations([1, 2, 3]);
```

- `do` で組み立てた「命令」は、関数を返す
- そうしてできた関数は、引数として「状態」の初期値を受け取る

# `State` モナドで「結果を戻り値として返す以外で表現する」

`do` の中で `... <- f(x)` という形で書かれた関数（命令）の呼び出しは、あたかも次のように見えるよう振る舞う:

1. 暗黙の変数「状態」を表す引数を加える
1. `f` を実行する
1. 結果を「状態」の部分とそれ以外の部分（`...`）に分けて、
    1. 「状態」を更新しつつ、
    1. それ以外の部分を見える結果として返す

# `State` モナドで「結果を戻り値として返す以外で表現する」

💡ポイント:

- あくまでも、`do { ... }` で囲まれた範囲内でのみ「状態」を隠す
- `do { ... }` の結果として手に入る関数は、「状態」の初期値を引数として受け取る、純粋な関数となっている
    -  `do { ... }` の外はやっぱり純粋な関数の世界

# `Either` モナドで「異常系の結果をまとめて処理する」

🙇二重の意味で時間がないので詳細は割愛します😢

- `State` モナドと同じように `do { ... }` で囲われた範囲内で、例外処理っぽいことを実現してくれる！

# ここまでのまとめ

- モナドは、`do { ... }` で囲まれた範囲内でのみ、モナドの種類ごとに決まったルールで、純粋な関数の制限を緩和してくれる
- 純粋じゃない<small>（ように見える）</small>部分をあくまでも `do { ... }` の中に留めてくれるため、純粋な関数の利点を損なわずに、普通の関数でできたことを再現できる

# 💔モナドが損なうもの

- `do { ... }` の中では純粋な関数の制限を緩和してくれる  
  ⬇️
- `do { ... }` の中では純粋な関数の利点を損なうこともある
    - 特に、`do { ... }` の中身が大きくなった場合！

# 💔例: `State` モナドが損なうもの

```js
do {
  foo <- doFoo(x, y);
  bar <- mutateBar();
  // ...
  // ... 何十行も続く ...
  // ...
  baz <- updateBaz(bar);
  // ... 更に続く ...
}
```

- `do` の中に隠れている「状態」は `updateBaz` の時点でどうなっている？

# 👿まだまだ損なうぞ！

- `State` モナドの「状態」はたかだか変数一つ分なのであまり困らないが...
- <small>（Haskellという）</small><ruby>現実世界<rp>（</rp><rt>リアルワールド</rt><rp>）</rp></ruby>には、「普通の関数」と実質変わらない、何でも出来てしまう `IO` モナドがある
    - 「IOを実際に使用するときの体験は他のプログラミング言語で入出力をするときとほぼ同じ」
        - （[去年の関数型まつりでの私の発表スライド](https://the.igreque.info/slides/2025-06-15-fp-matsuri) 34ページより）

# 🧐モナドを使うのは関数型プログラミングか？

- 純粋な関数の「引数からしか影響を受けないし、結果を返す以外に外部へ影響を与えない」という制約を緩めるということは、
- ある意味で純粋な関数から離れていくことでもある
- ➡️ 関数型プログラミングとも関係が薄くなってしまうのでは？  
  <small>（ようやくタイトル回収）</small>
    - これも一面では正しい

# 🙄モナドを使うのは関数型プログラミングか？

- 一方、`do { ... }` の外から見れば純粋な関数の性質を維持できるということは、
- 構文を拡張するだけで純粋な関数の可能性を広げられるということでもある
- ➡️ 🤗やっぱり密接に関係してる！

# 関数型プログラミングとは純粋な関数を諦めるプログラミングだ

結局のところ関数型プログラミングは、

- 「純粋な関数を中心としたプログラミング」だが、
- 「純粋な関数」にはそのメリット故の制約も多く、解決しづらい問題がある。
- 真に「純粋な関数」を活かすには、その限界を知った上で、
- モナドなどを使って、適宜その制約を緩めることも必要。
    - モナドはそれを実現する、最も有名でスマートな手段

# 参考（本文中に言及がなかったもののみ）

- [関数型プログラミング - Wikipedia](https://ja.wikipedia.org/w/index.php?title=%E9%96%A2%E6%95%B0%E5%9E%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0&oldid=108865091)
- [プログラミングHaskell 第2版](https://www.lambdanote.com/products/haskell)
- [How are monads not about ordering/sequencing? : r/haskell](https://www.reddit.com/r/haskell/comments/244gil/how_are_monads_not_about_orderingsequencing/)
- [What a Monad is not - HaskellWiki](https://wiki.haskell.org/What_a_Monad_is_not#Monads_are_not_about_ordering.2Fsequencing)
