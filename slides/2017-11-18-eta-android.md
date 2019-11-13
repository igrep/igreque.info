% HaskellでAndroidアプリを書いてみた
% Yuji Yamamoto (山本悠滋)
% 2017-11-18 DevFest Shikoku 2017

# はじめまして！ (\^-\^)

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≅ プリキュア歴 ≅ 約5年。
- 仕事はJavaじゃば！
    - でも最近シェルスクリプトばっかり書いてる気がするキラ！
- igrep.elというEmacsプラグインがありますが無関係です！

# 宣伝 hask(\_ \_)eller

- 今年3月末から[日本Haskellユーザーグループ](https://haskell.jp/)というコミュニティーグループを立ち上げ、その発起人の一人として活動しております。
    - 愛称: Haskell-jp
- [Slackのワークスペース](http://slackarchive.io/)や[Subreddit](https://www.reddit.com/r/haskell_jp/)、[ブログ](https://haskell.jp/)、[Wiki](http://wiki.haskell.jp/)など、いろいろ運営しております。

# 今日の話

- 😂 [Eta](http://eta-lang.org/)というHaskellをJVM向けに改造した言語でAndroidアプリを作ってみたけど失敗したよ！
    - Proguard難しいね！
- 💪 悔しいのでEtaがどうやってJavaの機能をHaskellで翻訳しているのかについて、Haskell（と、GHC）の各種機能を紹介しつつ語ります！

# やったこと・失敗したこと

動機:

- [GitHubのプロフィール](https://github.com/igrep)に載っているアレ<img src="/imgs/2017-11-18-eta-android/green.png" style="height: 1em;">を**是が非でも**埋めたい。
    - 😰（といいつつここ1年で2日ほど空きがある）
- 😤で、こんな[ズルするためのリポジトリー](https://github.com/igrep/daily-commits)を作って毎日コミットしている。
    - これを毎日更新したかどうか簡単にチェックできるアプリを作りたい

# 顧客が本当に必要だったもの

- 🏠ホーム画面に置くウィジェット
- 🛠️予めリポジトリーを指定
- 👆タップしたら OR 🕰️一定時間おきにGitHubのAPIを叩いて、
    - 最終コミット日時が今日の0時0分を以降であればアイコンを <img src="/imgs/2017-11-18-eta-android/green.png" alt="緑" style="height: 1em;"> に。
    - そうでなければ <img src="/imgs/2017-11-18-eta-android/red.png" alt="赤" style="height: 1em;"> に。

# 顧客が本当に必要だったもの

それだけ！

- ※GitHubのアレを <img src="/imgs/2017-11-18-eta-android/green.png" alt="緑" style="height: 1em;"> にする条件と厳密に一致してませんが、あしからず。

# やったこと・失敗したこと

- 🤔十分に簡単（そう）なものだし、Androidアプリの開発経験がほぼゼロな自分でもできるだろう...
- 😕 でもJava書きたくないな、Kotlinも面白そうだけど...。
    - 趣味に仕事(Java)を持ち込みたくないよね...。

# やったこと・失敗したこと

💡そういやこんな記事があった！

- [Haskell on Android using Eta](https://brianmckenna.org/blog/eta_android)

# Etaって？

- 🍴GHCという、Haskellのデファクトスタンダードなコンパイラーのフォーク。
- 既存のHaskellのコードとの高い互換性を保ったまま、
    - ☕HaskellのソースをJVMのバイトコードにコンパイルしたり、
    - ☕Javaのコードを呼び出したりできる。
- 詳しくはこの後！

# やったこと・失敗したこと

ほぼほぼ

1. ⌨️書いてみる
1. 😵Etaのバグにハマる
1. 📣[Gitter](https://gitter.im/typelead/eta)やGitHubで報告
1. 🔨直してもらう

- 😢の繰り返し

# やったこと・失敗したこと

😂いろいろ乗り越えてさあAndroidからGitHubのAPIを呼ぶぞ！というところで...

-
    ```
    ...
    Warning: there were 1 unresolved references to library class members.
      You probably need to update the library versions.
      (http://proguard.sourceforge.net/manual/troubleshooting.html#unresolvedlibraryclassmember)
    Warning: Exception while processing task java.io.IOException: Please correct the above warnings first.
    ```

# やったこと・失敗したこと

```
＿人人人人人人人人人＿
＞　突然のProguard　＜
￣Y^Y^Y^Y^Y^Y^Y^Y^Y￣
```

# やったこと・失敗したこと

- 最終的に開発を断念したのはProguardのエラーに阻まれたため
- Etaでコンパイルしたjarファイルには、実行時に必要な別のクラス（ランタイム）が大量に必要なため、MultiDexや不要なコードの削除が必須
- [頑張って `-dontwarn` や `-keep` を重ねてみるも](https://github.com/igrep/keep-me-contributing-hs/blob/815bb6a93be4914e699d5580455ff6e64d1460d7/app/proguard-rules.pro)、ゼロにはできず...。
- 🙏誰か詳しい人教えてください！

# やったこと・失敗したこと

- AndroidのライブラリーとEtaのランタイムのみで実行していた頃は問題にならなかった
    - それでも[元の記事](https://brianmckenna.org/blog/eta_android)にあった `-dontwarn` はコピペしたけども。
- Etaは残念ながら現状HTTP含めネットワーク系のHaskellのライブラリーを全然ポートできていないため、やむなくGitHubのAPIをJavaのライブラリーで実行しようとした結果。

# ~~一応のデモ~~

省略します... hask(\_ \_)eller

# やればよかったかもしれないもの

- [A Haskell Cross Compiler for Android – zw3rk – Medium](https://medium.com/@zw3rk/a-haskell-cross-compiler-for-android-8e297cb74e8a)
- [その後も続々更新されている](https://medium.com/@zw3rk/what-is-new-in-cross-compiling-haskell-b70decd4b3a6)。
- Androidはじめ、Haskellを各種環境向けにクロスコンパイルする取り組みが結構進んでいるらしい。
- ただし、こちらもかなり実験的なので、やってみないとわからないが、多分五十歩百歩だろう。

# 所感・反省

- 😥もともとEtaの（とか、周辺ツールであったりそのフォーク元のGHCやcabalだったりの）内部についての知識が少なかったためか、学びに繋げられなかったように思う。
- 😵バグを直してもらっても、どこがどう直ったのかさっぱり！
- 😰バグにハマるたび、ひたすら消耗するばかりだった...。

# おしまい

<div class="takahashiLike incremental">
... というのは悔しいので、予告通りEtaとHaskellのお話をします！😤
</div>

# 先にまとめ

- EtaがJavaの機能を呼び出すときは、
    - すでにあるGHCのFFIや、各種言語拡張を使いつつ、
    - Java Monadをはじめとする独自の型を定義して実現しています。
        - ＋ちょっとの文法の拡張
- 言語拡張はHaskellの成長のために欠かせないもの！

# 前提知識

題して！

<div class="takahashiLike incremental">
雰囲気だけは分かる！  
Etaを知るためのHaskellの基本！
</div>

# コメントの書き方

```haskell
-- これが行コメント。ここから先の例では主にこれを使う
{-
  これがブロックコメント。
  この後出てくる言語拡張を宣言するときにも使う
-}
```

# 型注釈

- Haskellは静的型付け言語なので、あらゆる値の型が実行前に分かってなければならない。
- なので、関数の引数や変数の型を明示する（型注釈をつける）ための構文がある。
    - でも実際のところ、型推論がめっちゃ強力なおかげで、多くの場合型注釈は書かなくてよいもの。

# 型注釈

```haskell
aPrime :: Int
aPrime = 9109

message :: String
message = "I love Eta!!"
```

# 型注釈

![](/imgs/2017-11-18-eta-android/type-annotation.png)

# 型注釈

```haskell
func :: Int -> Int
func x = x + 1
```

- `->` という記号が関数を表す
- この場合「`Int`を受け取って`Int`を返す関数」という意味

# ジェネリクスと型引数

- コンテナを表す型など、「任意の型」を扱う型で使用する。
- Haskellで「任意の型」（型変数）を表したいときは、型を書くところでアルファベット小文字を使う

```java
// Java!
Set<T>
```

```haskell
-- Haskell!
Set a
```

# ジェネリクスと型引数

![](/imgs/2017-11-18-eta-android/type-arg.png)

# ジェネリクスと型引数

- 例えば、整数(`Int`)の集合(`Set`)を表す型の場合
- 型引数`a`の代わりに`Int`を適用している

```java
// Java!
Set<Integer>
```

```haskell
-- Haskell!
Set Int
```

# ジェネリクスと型引数

- 引数を二つとる場合、スペースで区切る
- 小文字の`k`と`v`が型引数

```java
// Java!
Map<K, V>
```

```haskell
-- Haskell!
Map k v
```

# ジェネリクスと型引数

- 例えば、文字列(`String`)がキーで整数(`Int`)が値の連想配列(`Map`)を表す型の場合
- 型引数`k`, `v`の代わりに`String`と`Int`を適用している

```java
// Java!
Map<String, Integer>
```

```haskell
-- Haskell!
Map String Int
```

# 型クラス

```haskell
class SomeTypeClass a where
  method :: a -> Bool
```

- 「同じような特徴の型」をまとめるための仕組み
- ☝️のように、`class`というキーワードで始めるが、実際にはインターフェースと似てる
    - `method`という関数が使える型全般をまとめた型クラス`SomeTypeClass`の宣言
- またまた用語が紛らわしいのだけど「`Hoge`という型クラスに属する型」を「`Hoge`型クラスのインスタンス」と呼ぶ

# 型クラス

- これから紹介する型クラスは以下の通り。
- `Monad`: ファーストクラスな「文」っぽいものを表す型をまとめる
- `Class`: Etaにおいて、「Javaの型をラップした型」をまとめる
    - 😅（Etaの今後の仕様変更により、多分そのうち意識しなくて済むようになる）

# 記号関数

- Haskellではおなじみの演算子が大体みんな組み込みじゃない「普通の関数」
    - `+` `-` `*` `/` も！
    - `&&` や `||`も！
    - `=` とか、`::` とか、この後出る `<-` などは組み込み。

# 記号関数

- お気に入りの記号を組み合わせて、君だけの演算子も作れる！
- 調子に乗ると大体意味不明になるのでご利用は計画的に！
- [例えばLensライブラリー](https://www.stackage.org/haddock/lts-9.13/lens-4.15.4/Control-Lens-Operators.html)
    - ググラビリティが低いので、ご丁寧にLensライブラリーで使える演算子をすべて集めたページを用意している

# Monadとdo記法

- MonadはHaskellにおけるめっちゃ重要な型クラス
- もともとHaskellにはなかった、「文」的なものを提供してくれる

# 「文」的なもの？

- [文 (Statement)](https://ja.wikipedia.org/wiki/%E6%96%87_\(%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0\))
    - 「コンピュータプログラミング言語によるプログラムを構成するもののひとつで、一般に手続きを表すもの」

# 「文」的なもの？

Javaで言えば...

- これも文

    ```java
    System.out.println("Aho!");
    ```
- セミコロンで区切られてたり、

# 「文」的なもの？

Javaで言えば...

- これも文

    ```java
    if (isNantoka()) {
        System.out.println("Nantoka!);
        System.out.println("Kantoka!);
    }
    ```
- 複数の「文」がまとまっているのもまた文だったりする

# 「文」的なもの？

- Haskellにはほかのプログラミング言語でいう「文」にぴったり相当するものがない！
- 代わりに、いろいろなデータ型を「文」っぽく扱うことができる仕組みが存在する

# 「文」的なもの？

- 「文」っぽく扱うことができる型（をまとめた型クラス）: `Monad`
- `Monad`を「文」っぽく見せる構文糖: `do`記法

# `do`記法と`Monad`

`do`記法を使った例

- `do`以降に書いた一行一行が`Monad`型クラスの型の値
- 👇は`IO`という最もよく使われる`Monad`を使った`do`

    ```haskell
    do
      putStrLn "君の名前は？"
      name <- getLine
      putStrLn "いい名前だね！"
    ```

# `do`記法と`Monad`

```haskell
do -- <----------------------- do記法の始まり
  putStrLn "君の名前は？"   -- この行がIO Monad
  name <- getLine           -- この行もIO Monad
  putStrLn "いい名前だね！" -- この行もやっぱりIO Monad
```

- 一つの`do`ブロックに入る`Monad`のインスタンスは、1種類だけ
    - 👆のMonadでは`IO`しか使えない！

# `do`記法と`Monad`

一般化するとこんな感じ

```haskell
do
  result <- doSomeMonad
  moreMonad
  anotherMonadWith result
```

- 実行結果を`<-`という記号で代入できる

# `do`記法と`Monad`

`Monad`を実装した型によって、`do`に書いた各「文」と「文」の間でできることが異なる。

```haskell
do
  result <- doSomeMonad
  moreMonad
  anotherMonadWith result
```

# `do`記法と`Monad`

つまり、

![](/imgs/2017-11-18-eta-android/do1.png)

- ![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)でできることを、`Monad`を実装した各種型は自由に定義することができる

# `do`記法と`Monad`

例えば...

- `Maybe` `Monad`であれば![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)で処理が失敗した場合に、`do`ブロックの処理を中断することができる
- リスト `Monad`であれば![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)以降の文をリストの各要素に対して実行することができる
- `State` `Monad`であれば![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)で、`do`ブロックの中で暗黙に共有している状態を更新することができる
- `IO` `Monad`であれば![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)で入出力処理を実行したり、例外を投げたりできる
    - ほかの言語における、「文」と同じくらいいろいろなことができる

# `do`記法と`Monad`

（再掲）`Monad`型クラスに属する型によって、`do`記法の中の![「ここ！」](/imgs/2017-11-18-eta-android/koko.png)でできることが違う！

![](/imgs/2017-11-18-eta-android/do1.png)

# Foreign Function Interface (FFI)

- Haskellからほかのプログラミング言語(Cとか)の関数を呼んだり、
- Haskellの関数をほかのプログラミング言語から呼べるようにするするための仕組み

# Foreign Function Interface (FFI)

「[本物のプログラマはHaskellを使う - 第22回　FFIを使って他の言語の関数を呼び出す：ITpro](http://itpro.nikkeibp.co.jp/article/COLUMN/20080805/312151/?rt=nocnt)」  
から拝借した例を一つ。

# Foreign Function Interface (FFI)

例えば、C言語の`math.h`で定義されている`sin`関数を呼びたいとき。

```haskell
foreign import ccall "math.h sin" c_sin
  :: Double -> Double
```

- 「`math.h`で宣言されているCの関数`sin`を、`Double -> Double`という型の関数`c_sin`として呼び出す」という意味。

# Foreign Function Interface (FFI)

逆に`plusOne`というHaskellの関数をC言語で呼び出せるようにしたいとき

```haskell
foreign export ccall "plusOne" plusOne :: Int -> Int
```

# Haskellの標準とGHCの言語拡張

例えば、冒頭でも紹介した、[Etaのサンプル](https://brianmckenna.org/blog/eta_android)を開くと...

- 先頭になんかいろいろ書いてある！

    ```haskell
    {-# LANGUAGE DataKinds #-}
    {-# LANGUAGE MagicHash #-}
    {-# LANGUAGE TypeFamilies #-}
    {-# LANGUAGE TypeOperators #-}
    {-# LANGUAGE FlexibleContexts #-}
    {-# LANGUAGE OverloadedStrings #-}
    ```

# Haskellの標準とGHCの言語拡張

- これ以前に紹介したHaskellの機能は、すべて[Haskell 2010 Language Report](https://www.haskell.org/onlinereport/haskell2010/)という仕様書で定義されているもの。
    - まともなHaskellの処理系であれば、みんな実装していてしかるべき機能。
- でも、「それだけじゃ足りないよ！もっといろんな機能を加えたいよ！」という処理系開発者のために、**言語拡張**を定義するための構文がある。

# Haskellの標準とGHCの言語拡張

例えばGHCで...

```haskell
{-# LANGUAGE MultiWayIf #-}
```

- という特別なコメントをファイルの先頭に書いておくと、`MultiWayIf`という言語拡張が使えるようになります。

# Haskellの標準とGHCの言語拡張

```haskell
{-# LANGUAGE MultiWayIf #-}

...

if | x == 1    -> "a"
   | y <  2    -> "b"
   | otherwise -> "d"
```

- `if`/`else`がクールに書ける！

# Haskellの標準とGHCの言語拡張

なんだか闇魔法感がありますが！

- 言語拡張は、標準が更新されない間も様々な機能を追加できるようにするための、プラグイン機構
- 言語拡張を宣言する方法自体は[標準でも定義](https://www.haskell.org/onlinereport/haskell2010/haskellch12.html)されている
- 使う機能を明記することで、サポートしていない処理系がコンパイルしようとしてもわかりやすくエラーにできる

# Haskellの標準とGHCの言語拡張

- Haskellはプログラミング言語の研究者のための言語でもあるので、実験のために様々な拡張が作られてきた
- Etaの仕組みも言語拡張があってこそのもの！
- もちろん、次期標準である[Haskell 2020](https://mail.haskell.org/pipermail/haskell-prime/2016-April/004050.html)にもフィードバックされる（はず）！

# などなど

- Etaの機能を説明するに当たりほかにもいろいろ出てきますが、後は必要に応じて！

# ここまでのまとめ

- Haskellの言語拡張はHaskellの成長や、Etaの機能のために欠かせないもの！
- Haskellでは、`Monad`という型クラスで、「文」を一般化している
    - `Monad`に属する型クラスによって、`do`の中でできること（= 「文」の意味）を変えることができる

# もっと知りたい方は

- [エンジニアHub](https://employment.en-japan.com/engineerhub/)というブログメディアに、Haskellの入門記事を書きました！
    - [Haskellらしさって？「型」と「関数」の基本を解説！【第二言語としてのHaskell】](https://employment.en-japan.com/engineerhub/entry/2017/08/25/110000)
    - [実践編！Haskellらしいアプリケーション開発。まず型を定義すべし【第二言語としてのHaskell】](https://employment.en-japan.com/engineerhub/entry/2017/09/11/110000)
    - [発展編！ Haskellで「型」のポテンシャルを最大限に引き出すには？【第二言語としてのHaskell】](https://employment.en-japan.com/engineerhub/entry/2017/10/03/110000)
- 😅まぁ、上記の入門ではここで説明したことにたどり着く前に終わってしまうのですが...。

# もっと知りたい方は

- Haskellなんて知りたくないよ、という方には！
    - [igreque : Info -> JavaでMonadをはじめからていねいに](http://the.igreque.info/posts/2016/04-monad-in-java.html)

# もっと知りたい方は

繰り返しになりますが...

- [日本Haskellユーザーグループ](https://haskell.jp/)の[Slackワークスペース](https://haskell.jp/signin-slack.html)や[Subreddit](https://www.reddit.com/r/haskell_jp/)もあります！
- StackoverflowやteratailでHaskellタグをつけて質問すると、転送される[Slackのチャンネル](https://haskell-jp.slack.com/messages/C707P67R7/convo/C7Y71415W-1510496739.000024/)もあります！
- 再度の宣伝失礼！ hask(\_ \_)eller

# 閑話休題

- ここから先はEtaの話です！
- 同じく雰囲気だけでも知ってください！

# Haskellで型を定義する方法

例: `Int`をラップしただけの型`SomeType`

```haskell
data SomeType = SomeType Int
```

- 👆の例は実際に役に立つ例ではありませんが、あくまで例として。

# EtaでJava Wrapper Typeを定義する方法

例: おなじみAndroidの`Activity`クラスを使用したいとき

```haskell
data Toast = Toast @android.widget.Toast deriving Class
```

# EtaでJava Wrapper Typeを定義する方法

![](/imgs/2017-11-18-eta-android/jwt.png)

- 🙇恐らく、今後も仕様変更される箇所なので軽く流してください。
- 😅実は、すでに[公式サイトに書いてある方法](http://eta-lang.org/docs/html/eta-tutorials.html#defining-a-java-wrapper-type)の方が古かったりする...。

# ~~継承関係を表現したいとき~~

😞Type Familiesとかの説明がだるいのではしょるか...。

# EtaでJavaのメソッドを `import` する

引数をとらないメソッドの場合

```haskell
foreign import java unsafe "show"
  showToast :: Java Toast ()
```

- 基本的には、`foreign import ccall "math.h sin" c_sin`などと書いていたとの同じ。
    - FFIを利用している。
- では `Java Toast ()` とは？

# `Java Toast ()` とは？

Java Monad

- `IO` Monadと違い、型引数を二つとる
- `IO` をはじめMonad型クラスのインスタンスは、すべて型引数を1つとる

# `Java Toast ()` とは？

- 一つ目の型は、「なんのクラスか」を表す
    - この場合`Toast`
- 二つの型は、「実行した結果」の型
    - この場合`()`。Javaにおける`void`のようなもの

# `Java` Monadとは？

- <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> Haskellでは、`Monad`という型クラスで、「文」を一般化している
    - `Monad`に属する型クラスによって、`do`の中でできること（= 「文」の意味）を変えることができる
- `Java` Monadの場合は？
    - `do`の中で**Javaのメソッドが呼べる**
    - ＋`IO` Monadができること全般

# 引数を受け取るメソッドを `import` する

```haskell
foreign import java unsafe "setDuration"
  setDuration :: Int -> Java Toast ()
```

- <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> Haskellでは`->` という記号が関数を表す
- 「`String`を受け取って（`TextView`に対するメソッドが呼べる）`Java` Monadを返す」関数となる

# `static`メソッドを `import` する

```haskell
foreign import java unsafe "@static android.widget.Toast.makeText"
  makeText :: Context -> String -> Int -> Java a Toast
```

-  <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> 複数の引数を受け取る関数は「型1 -\> 型2 -\> ... -\> 戻り値の型」という形式で表される
    - 🙏ちょっとタイプしにくいけど、これはこれでメリットがあるのでご容赦を！
-  <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> 小文字で始まる型「`a`」は「任意の型」を表す
    - 特定のオブジェクトから呼ぶわけではない、`static`なメソッドはこのように書く。

# `static`メソッドを `import` する

```haskell
foreign import java unsafe "@static android.widget.Toast.makeText"
  makeText :: Context -> String -> Int -> Java a Toast
```

ここでは`Java` Monadの二つ目の引数が`Toast`であることから分かるとおり、`Toast`を戻り値の型として返す

# `static`メソッドを `import` する

👇使うときはこう

```haskell
do
  toast <- makeText someContext "Hello, Widget written in Eta!" 1
  ...
```

- <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> 結果を `<-` で代入する

# `Java` Monadを使ってJavaのメソッドを呼ぶ

```haskell
do
  ...
  toast <.> showToast
  toast <.> setDuration 0
```

- <img src="/imgs/haskell_logo.svg" alt="緑" style="height: 1em;"> Haskellでは好きな記号を組み合わせて、新しい演算子を作れる
    - Etaの場合は、メソッドを呼ぶ専用の演算子として「`<.>`」を作った

# Haskellの関数をJavaで呼べるようにする

```haskell
foreign export java "@static info.igreque.keepmecontributinghs.KeepMeContributingWidgetProviderHs.onUpdate"
  onWidgetUpdate :: Context -> Java a ()
```

- 😰残念ながら現状`static`メソッドしか`foreign export`できない
    - `foreign export java "@static クラス名.メソッド名"` みたいな形式のみが使える
    - でもHaskellerはある意味みんなstaticおじさんなので、実際そんな困らないと思う
- やはり戻り値は`Java a`な`Java` Monadとなる

# Haskellの関数をJavaで呼べるようにする

実際に私が実装した関数（一部改変）

```haskell
onWidgetUpdate :: Context -> Java a ()
onWidgetUpdate c = do
  toast <- makeText c "Hello, Widget written in Eta!" 1
  toast <.> showToast
```

# Haskellの関数をJavaで呼べるようにする

Java側ではこう呼ぶ

```java
import info.igreque.keepmecontributinghs.KeepMeContributingWidgetProviderHs;

...
public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
    KeepMeContributingWidgetProviderHs.onUpdate(context);
}
```

# まとめ

- EtaはGHCという、Haskellのデファクトスタンダードなコンパイラーのフォーク。
- EtaはHaskellとGHCにもともと備わった豊富な機能をフルに活かして、Javaのクラスやメソッドをいい感じにHaskellに統合してくれる！
    - ただし、現状めっちゃバグだらけだし機能不足なんでみんなは手を出すなよ！
- ここまで書いたリポジトリーを一応[igrep/keep-me-contributing-hs](https://github.com/igrep/keep-me-contributing-hs)に上げました hask(\_ \_)eller
