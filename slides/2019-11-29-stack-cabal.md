---
title: 最近のstackとcabalについて簡単に
author: YAMAMOTO Yuji (山本悠滋)
date:  2019-11-29 Gotanda.hs #1 @HERP

---

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約7年。
- 趣味Haskeller兼仕事Haskeller @ [IIJ-II](https://www.iij-ii.co.jp/) 😁
- igrep.elというEmacsプラグインがありますが無関係です！

# 宣伝 hask(\_ \_)eller

- 2017年から[日本Haskellユーザーグループ](https://haskell.jp/)というコミュニティーグループを立ち上げ、その発起人の一人として活動しております。
    - 愛称: Haskell-jp
- [Slackのワークスペース](https://haskell.jp/signin-slack.html)や[Subreddit](https://www.reddit.com/r/haskell_jp/)、[ブログ](https://haskell.jp/)、[Wiki](http://wiki.haskell.jp/)など、いろいろ運営しております。

# 宣伝 hask(\_ \_)eller

- 「haskell.jp」というドメインを活用し、「公式面して」発信する人を募集してます。
    - ブログを書いたり「Haskell-jp」としてイベントを作ったり、などなど。
- 👇の大きなゴールに共感し、節度を守って活動していただける方なら誰でも🆗
    - 日本にHaskellを普及させる
    - 日本を代表するHaskellのユーザーグループとなる

# 📝今日話すこと

- 👍👍今はcabalでもstackでもどっちでもいいんじゃないかな！
- cabalに対するstackのいいところ
- stackに対するcabalのいいところ
- 敢えて両方使えばいいんじゃないかな！
- おまけ: かつてのcabalのいけてなかったところ

# ⚠️おことわり

- 🙇ここでいう「cabal」は「[cabal-install](http://hackage.haskell.org/package/cabal-install)」のことです
    - いわゆる「cabalコマンド」
    - [Cabal](hackage.haskell.org/package/Cabal)というcabal-installが使っているライブラリーも同じ名前なので注意
- 🙇基本的にcabal-install 3.0を前提としています

# 👍👍今はcabalでもstackでもどっちでもいいんじゃないかな！

- 💪cabalの問題を解決するために生まれたけど、今はcabalも進化した！
- 今日はそんな今のcabalとstackを比較します
- ⚠️網羅的な比較ではないし、「※個人の感想です」も多いのでご注意を！

# cabalに対するstackのいいところ

- 🤗エラーメッセージが優しい
- 📦hpackの組み込みサポート
- 😏気の利いたオプションがある
- ⏬GHCのインストールが楽ちん

# cabalに対するstackのいいところ

🤗エラーメッセージが優しい

- cabalは特にcabalファイルの構文エラーがわかりづらい
    - stack側にぴったり相当するものがないので単純比較はできない
    - hpackを使えばそのわかりづらさに遭うリスクも減る
- stackは「このパッケージは今のresolverにないからこの行をstack.yamlに書いてね！」と教えてくれる、などなど

# cabalに対するstackのいいところ

📦hpackの組み込みサポート

- 前述のcabalファイルのわかりづらさに付き合う必要がなくなる
- hpackはcabalよりもDRYに書きやすい
    - でも、cabalも「common stanza」機能を実装したのでその差は縮まった
    - [cabal-fmt](http://hackage.haskell.org/package/cabal-fmt)ができたことでmoduleの列挙も半自動化できる
- 🙏個人的にはcabalに慣れて欲しい気持ち

# cabalに対するstackのいいところ

😏気の利いたオプションがある

- `--file-watch`
    - ファイルを監視して自動でリビルド！
- `--pedantic`
    - `--ghc-options=-Wall -Werror`と等価
- `--fast`
    - `--ghc-options=-O0`と等価

# cabalに対するstackのいいところ

⏬GHCのインストールが楽ちん

- ご存知のとおり、`stack build`するだけで、必要なGHCがインストールされてなければ自動でインストール
- GHCのインストールしたいだけの時は`stack setup`

# stackに対するcabalのいいところ

- ❄️enable executable static
- 🚧開発版のGHCでも！
- ◀️Backpack使うなら必須
- 📚一つのcabalファイルに複数のライブラリーが！
- ⭐️実はStackageの恩恵を受けるのも簡単

# ❄️enable executable static

- `cabal build --enable-executable-static`
- 昨今のはやり、シングルバイナリーが簡単に作れる！
- ⚠️ただし、主にglibcの都合で結局実行時にglibcが必要になってしまうケースがあるので注意
    - [GNU ldで一部をスタティックリンクにする](https://fukasawah.github.io/posts/2019/01/07/a-part-static-link-in-gnu-ld/)

# 🚧開発版のGHCでも！

- `-w`（または`--with-compiler`）オプションで使いたいGHCへのパスを明示すれば、いつでも好きなGHCを使える！
- cabal 2.xだと`--with-ghc`オプションのようです

# ◀️Backpack使うなら必須

Backpack: GHC 8.2から追加された機能

- 「moduleのinterface」的なものができる
- 詳しくは[Haskell Backpack 覚え書き](https://matsubara0507.github.io/posts/2017-12-12-backpack-memo.html)を
- 個人的には「やっぱりだいたい型クラスでどうにかなるじゃねーか」という印象
    - 型クラスだとより筋力💪が必要なケースをすっきりできるみたいだけど...
- [stackは当分サポートしそうにない](https://github.com/commercialhaskell/stack/issues/2540)

# 📚一つのcabalファイルに複数のライブラリーが！

- [Multiple public libraries in a package · Issue #4206 · haskell/cabal](https://github.com/haskell/cabal/issues/4206)
- cabal 3.0からサポート
- 恐らく前述のBackpackのためにもあってしかるべき機能

# 📚一つのcabalファイルに複数のライブラリーが！

例えば`aeson`パッケージを作ったとき:

- pretty printerとして`aeson-pretty`を作ったり
- `Value`型のインスタンスのためのパッケージを作ったり
- などなど、今まで分かれていた関連するパッケージを、一つのパッケージのライブラリーとして配布できる

# ⭐️実はStackageの恩恵を受けるのも簡単

例えばLTS 14.16に書かれているバージョンのパッケージを使いたいとき:

```
curl https://www.stackage.org/lts-14.16/cabal.config > cabal.project.freeze
```

- たったこれだけ！

# ⭐️実はStackageの恩恵を受けるのも簡単

コツ:

- `cabal v2-build`を実行する前に`cabal v2-update`しておくと、[Hackage Metadata Revision](https://github.com/haskell-infra/hackage-trustees/blob/master/revisions-information.md)の問題を回避できます
- stackはこの辺の問題がそもそも起こらないようにうまいこと管理しているようなのでやっぱりstackの方がフレンドリー
    - 具体的には、Stackageにパッケージが入ったtarballのチェックサムなど、より詳細な情報を書くことで解決している

# 敢えて両方使えばいいんじゃないかな！

- 例: stackをGHCのインストールに使ってビルドするときはcabal:
    - `cabal v2-build -w "$(stack path --compiler-exe)"`
    - 現状私は惰性でstackを使ってcabalの機能が欲しいときはこうする
    - stackがインストールしたGHCを再利用できるのがミソ

# おまけ: かつてのcabalのいけてなかったところ

- 「同じパッケージの同じバージョンは<small>（一つのパッケージDBにつき）</small>一つまで！」という制約が
- 🤔なぜそれではダメ？
    - 「同じパッケージの同じバージョン」かつ、「どのパッケージのどのバージョンを使ってビルドしたか」の**組み合わせも一通りだけ**、という制約もあるから

# おまけ: かつてのcabalのいけてなかったところ

- 図解するのは面倒なので[How we might abolish Cabal Hell, part 2](http://www.well-typed.com/blog/2015/01/how-we-might-abolish-cabal-hell-part-2/)を見よう！

# 参考・併せて読みたい

- [Backpack for Stack · Issue #2540 · commercialhaskell/stack](https://github.com/commercialhaskell/stack/issues/2540)
- [GNU ldで一部をスタティックリンクにする](https://fukasawah.github.io/posts/2019/01/07/a-part-static-link-in-gnu-ld/)
- [Haskell Backpack 覚え書き](https://matsubara0507.github.io/posts/2017-12-12-backpack-memo.html)
- [Well-Typed - The Haskell Consultants: How we might abolish Cabal Hell, part 2](http://www.well-typed.com/blog/2015/01/how-we-might-abolish-cabal-hell-part-2/)
- [Why Not Both? - fommil - Medium](https://medium.com/@fommil/why-not-both-8adadb71a5ed)
- [Multiple public libraries in a package · Issue #4206 · haskell/cabal](https://github.com/haskell/cabal/issues/4206)
- [cabal コマンドとの対応表](https://haskell.e-bigmoon.com/stack/tips/cabal.html)
- [cabal-fmt の紹介](https://haskell.e-bigmoon.com/posts/2019/10-07-cabal-fmt.html)
