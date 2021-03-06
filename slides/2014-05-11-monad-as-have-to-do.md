---
title: 「やらなければならないこと」としてのHaskellのMonad
author: 山本悠滋
date: 2014-05-11

---

# はじめまして！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 25歳♂
- [Sansan](http://www.sansan.com/)という会社でRailsを触ってます。
- [Haskellの勉強会](http://connpass.com/series/754/)をツキイチでやってます！

# 今日話すこと・話さないこと

- やたら難しいと言われる**Haskellの**Monadについて私なりの理解を説明してみます。
    - これ↓
    ```haskell
    class Monad m where
      return :: a -> m a
      (>>=) :: m a -> (a -> m b) -> m b
      -- 以下略
    ```
- **圏論の**モナドはよくわかりません！
- 「もう知ってるぜ！」という部分も多いかとは思いますがあしからず。

# 先に結論

- HaskellのMonadを \
  「関数が値を返す度に**やらなければならないこと**」 \
  として捉えると、 \
  なんだかいろいろスッキリ理解できたよ！

# Monadは型クラス

- （再掲）こんな感じのやつ↓

    ```haskell
    class Monad m where
      return :: a -> m a
      (>>=) :: m a -> (a -> m b) -> m b
      -- 以下略
    ```

# そもそも型クラスって

- まぁ言ってしまえば
    - JavaやC#などのinterface
    - Rubyのmix-inされるmodule
- みたいなもの
- **=\> 同じ振る舞いをする型達を、ひっくるめて扱う仕組み**

# 型クラスのいいところ

- 新しい型を作った時、必要なメソッドを定義しておくだけで、 \
  **その型クラスに対して使える色々な関数が使える！**
- 新しい型に固有な、**新しい型のみに必要な処理**は、 \
  必要な（未定義の）メソッドに**全て押し込めちゃえばいい！**

# Monadの場合は？

- 必要なreturnメソッドと(\>\>=)メソッドを定義しておくだけで！
    - do記法を使ったり、
- いろいろできる！
- 新しいMonad（クラスのインスタンス）に**固有な処理は**、 \
  必要な（未定義の）メソッドに**全て押し込めちゃえばいい！**

# ここで(\>\>=)を見てみましょう。

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- 他の型クラスと同様、Monadも必要なメソッド(\>\>=)に、 \
  固有の処理を書くことで、抽象化している。

# ここで(\>\>=)を見てみましょう。

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- 例えば...
    - Maybeでは、`m a`の`a`を`(a -> m b)`に渡すため、 \
      **Just aなのかNothingなのかどうか判定している**
    - Readerでは、`m a`の`a`を`(a -> m b)`に渡すため、 \
      **関数に、足りない分の引数を与えている**
    - Parserでは、`m a`の`a`を`(a -> m b)`に渡すため、 \
      **与えられた文字列を消費している**

# ここで(\>\>=)を見てみましょう。

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- いずれも、
    - `m a`の`a`を`(a -> m b)`に渡すために、 \
      **必要な処理をそれぞれ持っている。**
- そして、
    - `(a -> m b)`が返した`m b`をまた別の関数に渡すよう、必要な処理を繰り返している。

# つまり！！

- Monadは(\>\>=)の`m a`の`a`を`(a -> m b)`に渡す部分に、 \
  やらなければならないことをすべて押し込んでいる！
- `(a -> m b)`が値を返す度に、 \
  別の`(a -> m b)`な関数にMonadに包まれていない値を渡すために、 \
  やらなければならないことを(\>\>=)に任せている。

# 要するに！！

- `(a -> m b)`という型の、 \
  **値を返す度に、やらなければならないことがある関数** \
  がいっぱいある時、Monadは役に立つ。

# 例えば！！

- 「失敗したのかどうか、実行する度に確認しなきゃいけない」 \
  関数がいっぱいあるときは、 \
  **=\> Maybe Monad**
- 「実行する度に、結果のログを追記しなきゃいけない」 \
  関数がいっぱいあるときは、 \
  **=\> Writer Monad**
- 「実行する度に、入出力など、何かしら副作用のある計算をしなきゃいけない」 \
  関数がいっぱいあるときは、 \
  **=\> IO Monad**

# で、なにがうれしいの？

- 「[文脈](http://d.hatena.ne.jp/kazu-yamamoto/20110413/1302683869)だ！」とか、
- 「[手続き](http://fumieval.hatenablog.com/entry/2013/06/05/182316)だ！」とか、
- 「いや[モナド](http://fumieval.hatenablog.com/entry/2013/06/28/224439)だ！」とか、
- いろいろとMonadを簡単に言い換える言葉は多く出てきたけど、 \
  どれも結構抽象的で、ピンと来なかった。

# で、なにがうれしいの？

- それに対して「関数が値を返すたびにやらなければならないこと」だと、
    - 少なくともわれわれプログラマはイメージしやすい（はず）。
    - あくまでも「型クラスとしてのMonad」の性質に即して説明できる。
    - 「どう役立つか」説明できるので、メリットを感じさせやすい。
        - 特に「毎回やらなければならないことを一箇所にまとめられる」と言えば、
          コードのDRYさに敏感な人に効果がありそう。
    - 「失敗系」とか「状態系」とかに分けなくていい。

# まとめ

- HaskellのMonadは型クラス
- 型クラスは、同じ振る舞いをする型達を、まとめて扱うために使用する。
- Monadは「値を返すたびにやらなければならないこと」をまとめる。
- こうして、おびただしい数のMonadチュートリアルの歴史に、
  また一つ新たなページを刻んでしまうのであった...。
