---
title: Monadなんてどうってことなかった話
author: 山本悠滋
date: 2015-03-21 モナド基礎勉強会

---

# こんにちは！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 25歳♂
- [Haskellの勉強会](http://connpass.com/series/754/)を毎月やっとります。

# Monadなんてどうってことなかった

- ただの型クラスだった
- 予めことわるとここでのMonadはプログラミングで使うMonadだった
- 特にHaskellのMonadが中心だった
- ※あくまでもMonadを「使う」ことしかしないただのプログラマからの主張である点をご容赦ください。 `vim(_ _)mer`

# Monadなんてどうってことなかった

- ただの型クラスだった
- こういう定義の型クラスだった
    ```haskell
    class Monad m where
      return :: a -> m a
      (>>=) :: m a -> (a -> m b) -> m b
    ```

# ただの型クラスだけど違った

- なんか変な使い方ができる
    ```haskell
    hoge uID = do
      fname <- lookup uID firstNameDB
      lname <- lookup uID lastNameDB
      return $ fname ++ lname
    ```
- だったり、

# ただの型クラスだけど違った

- こんなん
    ```haskell
    foo = do
      tell ["hello, "]
      tell ["world!"]
    ```
- だったり、

# ただの型クラスだけど違った

- こんなんだったり...。
    ```haskell
    main = do
      putStr "こんなんだったり"
      replicateM_ 3 $ do
        threadDelay 1000000
        putStr "."
      putStrLn "。"
    ```
- 何がどうなってんの！？

# 間でなんかしてるだけだった

- ![](/imgs/2015-03-21-do1.png) の場合、

# 間でなんかしてるだけだった

- ![](/imgs/2015-03-21-do2.png)

- ![](/imgs/2015-03-21-do2-frame.png) のところでなんかしてるだけだった。
- 具体的にはJustかNothingか判定してるだけだった。

# 間でなんかしてるだけだった

- ![](/imgs/2015-03-21-do3.png) の場合、

# 間でなんかしてるだけだった

- ![](/imgs/2015-03-21-do4.png)

- ![](/imgs/2015-03-21-do4-koko.png) のところで（`tell`を実行するたびに）なんかしてるだけだった。
- 具体的には引数に与えたものをログとして追記してるだけだった。

# desugarしたらもっと簡単だった

```haskell
lookup uID firstNameDB >>= (\fname -> ...)
```

- `>>=` がなんかしてる！
- やっぱりJustかNothingか判定してる！

# ほかも大体一緒だった

- List: 要素を1個ずつ取り出してる！
- State: 関数が返した新しい状態で更新してる！
- Parser: 与えられた文字列を消費してる！
- IO: なんかいろいろやってる！

# ほかも大体一緒だった

- なんやかんやで大事なことはだいたい`>>=`の中でやってる！
- だからMonadはMonadとしてひとくくりにできる！！

# 同じなのは

- 例のモナド則。

# 例のモナド則

- 「実質何もしない」処理(`return`)があること

# 例のモナド則

- `do`記法で
    ```haskell
    do
      a <- do
        b <- foo
        bar b
      baz a
    ```
- みたいに書いたり、

# 例のモナド則

- `do`記法で
    ```haskell
    do
      b <- foo
      do
        a <- bar b
        baz a
    ```
- みたいに結合の仕方に気を使わなくてよくなっていること
    - （この例と前のスライドの例が必ず同じ意味になること）

# 違うのは

- `>>=`でやってること。

# `>>=`でやってること

- 「例のモナド則」を満たせば何だっていい
- およそ「手続き」っぽいものであればなんでもいい。
    - `State`も、`IO`も、あるんだよ

# `>>=`でやってること

- 何もしてなくたっていい(`Identity` Monad)
- 仕事してなくってもいい(ニート Monad)
- 複数のMonadがやってることを寄せ集めても（大抵）いい
    - Monad Transformer

# 何だったんだ...

- 「何でもいい」から難しい。
- なんだかいろいろできるのでまとまらない（ように見える）
- そのクセ`do`記法なんて用意して特別扱い。

# まとめ

- HaskellのMonadはあくまでも型クラスだった
- 大事なことはだいたい`>>=`でやってた
- やってることはみんな違った
    - みんなちがって、みんないい。
    - ニートでもいい。
- 何でもできるからよくわからなくなっていた
