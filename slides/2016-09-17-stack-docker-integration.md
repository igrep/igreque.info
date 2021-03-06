---
title: Introduction to Stack's Docker Integration
author: Yuji Yamamoto (山本悠滋)
date: 2016-09-17 Haskell Day 2016

---

# Nice to meet you! (\^-\^)

[Yuji Yamamoto](https://plus.google.com/u/0/+YujiYamamoto_igrep/about) ([\@igrep](https://twitter.com/igrep)) age 27.

- NO RELATION WITH Emacs plugin "igrep.el"!

# Nice to meet you! (\^-\^)

- Software Engineer at GMO CLICK Holdings, Inc.
    - <img src="/imgs/gmo-click-en.svg" alt="" width="420" height="25">
    - Writing online trading market of GMO CLICK Securities, Inc. in Java.
- Hobby Haskeller.
    - Using Haskell for 4 years.
- Holding [workshop of Haskell](http://connpass.com/series/754/) (almost) every month.

<!--
GMOクリックホールディングスという会社で働いております。
GMOクリック証券というネット証券のバックエンドをJavaで書いています。

Haskellは趣味でやっていて、
書いた量はそんなに多くないですが、始めてから大体4年ちょっとたちます。

おおむね毎月Haskellの勉強会をのんびりやっています。
こちらももう始めて3年以上たちますね。
-->

# Nice to meet you! (\^-\^)

(￣\^￣) Professional Haskeller.

- (;\^ω\^) Used to be. Just for a month
- (;\_;) Using Haskell was given up
    - Due to difficulty of teaching my colleagues...

<!--
職業Haskeller,

でした。たった一ヶ月だけですが。
とある新しいプロジェクトでHaskellを導入しようと頑張ったのですが、結局あきらめることになってしまいました。
やっぱりHaskellをメンバーに教えるのは難しいですね！
-->

# Advertisement m(\_ \_)m 1

HaskellJP wiki:

- <http://wiki.haskell.jp> “〆(ﾟ\_ﾟ\*)
- Anyone can edit with a GitHub account!
- The most helpful page: [Haskellに関する日本語のリンク集](http://wiki.haskell.jp/Links)
    - Haskell-related pages in Japanese
- Recently all edits are only by me... (;\_;)

<!--
宣伝一つ目。

HaskellJP wikiというのがあるのを忘れないでください。
GitHubアカウントがあれば誰でも編集できます！
「Haskellに関する日本語のリンク集」というページが一番おすすめです！
元々岡部さんという方が管理していたのを私が引き継いだのですが、残念ながらそれ以降私しか編集してません。
-->

# Advertisement m(\_ \_)m 2

- Published a blog post 「[JavaでMonadをはじめからていねいに](http://the.igreque.info/posts/2016/04-monad-in-java.html)」 “〆(ﾟ\_ﾟ\*)
    - Monad in Java from the beggining
- (￣\^￣) Told the relation between  
  **the `do` notation and the associative law most clearly**!

<!--
宣伝二つ目。

今度は純粋に私のもので恐縮ですが、「JavaでMonadをはじめからていねいに」という記事を書きました。
基本的にはHaskellは知らないけどJavaを知っている人向けの内容なのですが、HaskellのMonad自体の説明、特にdo記法とMonad則の関係の説明に関しては、これ以上ないぐらい丁寧に説明したつもりなので、その辺が曖昧だという方にもおすすめです！
-->

# I'm gonna talk about...

- What is Stack's Docker integration
- How it works
- Tips on using it
- Case study
    - (\^w\^) May help you to convince your boss to adapt Haskell!

<!--
以上宣伝です。
今日お話しすることは

- Stack Docker integration機能とは
- 仕組み
- 使用時の注意事項
- 実際に役に立ったケース
- Haskellを採用するための、みなさんのボスへの説得材料になればいいな、なんて思います。
-->

# I'm NOT gonna talk about...

- Basic usage of Stack
- Basic usage of Docker.
- Programming language Haskell itself.

<!--
で、今日お話ししないことは、

- Stackの基本的な使い方
- Dockerの基本的な使い方
- Haskellそれ自体の話

です。これらのことは、すでにネットに割りとよい資料が揃っているはずです。
Haskellそれ自体の話はまだまだ難しいかもしれませんが。
-->

# TL;DR

With Stack's Docker integration,

- (\^-\^) You can always build production-ready application  
  **as easily as you use `stack` command as usual**.

<!--
先にまとめますと、
StackのDocker integrationという機能を使えば、本番で動くHaskellアプリが、いつも通りstackコマンドをたたくだけで作れちゃう、というお話です。
-->

# Background

<!-- 前提知識 -->

How does GHC make Haskell code run?

- Emit native executables!
- Usually single, self-contained!
- Just put the executables to deploy!
    - Stack itself is actually single binary!

<!--
- ネイティブコードを吐く
- 必要なファイルは1個だけ！
- デプロイするときは実行ファイルをぺって置くだけ！
    - 事実Stack自身もそうやって作られている！
-->

# But...

- You must build for your production server!
    - Linux!
    - Dependent system (C) libraries and their version.
    - ... and so on!
- Corss-compilation with GHC is hard...

<!--
ところが、実際にはネイティブコードである以上、本番環境に向けていろいろ工夫してビルドしないといけません。
Linuxを開発環境で使ってない、という方も当然多いでしょうし、
依存するCのライブラリーのバージョンなんかも気にしないといけないかもしれません。
そういうケースのためにGHCはクロスコンパイルもできますが、結構面倒くさいらしいです。
-->

# With Stack's Docker integration,

- Build **directly for your production** environment.
- Just by `stack build` as usual.

<!--
そんなときにStackのDocker integrationを使うと！

- 本番環境のための実行ファイルがその場でビルドできちゃいます！
- いつもどおり`stack build`コマンドを叩くだけでいいんです！
-->

# Stack's Docker integration does:

- Wrap `docker` command.
- Make almost all operation of stack on the container.
    - Setup GHC.
    - Install dependencies.
    - Then build your app!
    - Run tests.

<!--
で、そのstackのdocker integrationがなにをしているのかと言いますと、

dockerコマンドをラップして、
GHCをインストールしたり、
依存関係を解決したり、
ビルドしたり、
テストしたり、
なんてことの、ほとんどすべてをdockerのコンテナ上で行うようになります。
-->

# How to use

1. Append `docker` option to `stack.yaml`
    ```yaml
    docker:
        enable: true
    ```
1. Run `stack` `build`/`install`/`setup` as usual.

<!--
次に使い方ですが、

stack.yamlを編集して、docker enable trueを追加してください。
後はいつも通りstackコマンドをたたくだけ！
-->

# How it works

※Changes by the configurations.

1. Create a temporary container just for executing stack's subcommands.
1. Share the project directory and `~/.stack` by mounting.
    - Where dependencies and build artifacts are saved.
1. `stack` command runs in the container.
1. Delete the temporary container
    - Build dependencies and artifacts are still persisted.

<!--
どういう風に動いているのか、もう少し細かく解説しますと、
実行するstackのサブコマンド専用の一時的なコンテナを作ります。
.stackディレクトリーとか、必要な諸々のディレクトリーを共有するようdockerの共有volumeを作ります。

で、stackはbuildコマンドとかをそのコンテナの中で実行します。
終わったらコンテナは削除します。
コンテナは消えちゃうんですが、コンテナの中で作ったもろもろのもの、
依存ライブラリーとかビルドしたアプリとかは、共有ボリュームに入っているので生き残ります。
-->

# How it works (cont)

5. Now you can upload the executable to your production, staging, or any target server!

<!--
で、もうその時点で、
あとは共有ボリュームに入っていたその実行ファイルを、検証環境なり本番環境なりにアップロードするだけ、な状態にしてくれます。
-->

# ☆ Tips on using Stack's Docker integration ☆

- ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image
- 三┏( \^o\^)┛ Go over the proxy!
- (x\_x) DON'T overwrite `ENTRYPOINT`!

<!--
続いて、Stack docker integrationを使う際のコツをいくつかお話しします。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

- Default: Stack's original image (based on Ubuntu)
- How to use CentOS/Debian/Arch?
- How to install C libraries or any other non-Haskell dependencies?

<!--
第一に、自分で作ったDockerイメージを使いたいときについて、です。

標準では、stackがDockerイメージまで用意してくれます。
Ubuntuを元に作ったものらしいのですが、
うちではCentOSだよ、とかうちではDebianだよ、とかいろいろニーズがありますよね。

ほかにも、Cのライブラリーとか、OSのコマンドとか、Haskell以外の依存関係がビルドやテストに必要、なんてのもあるでしょうね。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Edit `stack.yaml`

```yaml
docker:
  repo: "centos:6"
```

<!--
そういう場合には、使用するDocker imageを作ってしまいましょう。
stack.yamlを更に編集して、「repo」を指定してください。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Edit `stack.yaml`

```yaml
docker:
  repo: "https://your-docker-repo/image:latest"
```

<!--
Dockerのリポジトリーの名前やURLを指定したり、
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Or...

```yaml
docker:
  image: "<some_image_id_or_tag>"
```

<!--
あるいは、「image」という設定項目で、
ローカルでビルドしたDocker imageのidやtagを指定することもできます。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Requirement for Orignal Images:

- GHC must be installable (or already installed):
    - libgmp
- Tools to build C sources.
    - gcc, make etc.

<!--
で、このオリジナルなDocker imageなんですが、stackのDocker integrationで使うには当然いろいろ要件があります。  

GHCをインストールしておくか、GHCがインストールできるようになっていなければなりません。
一番必要なのはlibgmpですねー。
その他、なにかしらGHCやら依存ライブラリーのビルドの際使うものが必要みたいです。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Requirement for Orignal Images:

- Or, install stack itself in the image in advance.

<!--
あるいは、割と確実な方法として、Docker imageにあらかじめstackを入れちゃう、という方法もあります。
-->

# ᕦ(ò\_óˇ)ᕤ  Build on your own Docker image

Specify stack-exe

```yaml
docker:
  stack-exe: image
```

<!--
そうした場合などには、stack.yamlを編集して、stack-exeという項目に「image」という値をセットしてください。
stackのDocker integrationを使ったとき、imageに入っているstackコマンドを使ってビルドしてくれるようになります。
-->

# 三┏( \^o\^)┛ Go over the proxy!

```yaml
docker:
  env:
    http_proxy: http://proxy.example.com
```

<!--
次に、会社のプロキシを超えないといけないときです！

つらいですよね。私も今の職場に移ってからさんざん泣かされました。
この場合もstack.yamlを編集してください。
docker runコマンドのオプションを使っているんでしょう、実行時の環境変数を指定して、http_proxyなどを書き換えることができます。

そもそもstackコマンドがアクセスするサイトがプロキシでブロックされている、なんて場合は管理者に泣き寝入りするしかないですが。。。
-->

# 三┏( \^o\^)┛ Go over the proxy!

May also need build-time-arguments...

```bash
$ docker build --build-arg=http_proxy=...
```

<!--
それから、これはstackではなくdockerコマンドの話ですが、自分で作ったDocker imageを使いたい場合で、会社のプロキシに阻まれるような場合、恐らくdockerイメージのビルド時にも何かしら制限がかかると思うので、
dockerコマンドのbuild-argというオプションを使いましょう。
Docker 1.9から使えるはずです。
-->

# (x\_x) DON'T override `ENTRYPOINT`!

```Dockerfile
ENTRYPOINT your-cool-entrypoint-command
```

- Stack uses `ENTRYPOINT` internally!

<!--
もう一つ。
自分でDocker imageを作った場合についやっちゃうかもしれないんですが、
DockerfileのENTRYPOINTは指定「しない」でください。
stackのdocker integrationが内部的に使ってますので、指定すると確実にバグります。
-->

# Case study

- Tiny mock server to test with an external Web API.
- Must run on the staging server.
    - CentOS 6

<!--
それではここで、弊社、GMOクリックホールディングスで実際に私が経験して、stackのdocker integrationが便利だと感じたケースを紹介しましょう。

検証環境で使う、とあるWeb APIのmockサーバーが必要でした。
検証環境のサーバーはCentOS 6でした。
-->

# Case study

- Never mind zlib/libgmp/etc's diff in version, installation path.
- **Production-ready executables are always built** on my development machine!
- Just by the familliar `stack` `build`/`exec`/...
- Then `scp` the executable to our server!
    ```
    stack install
    scp ~/.local/bin/executable server@example.com:/
    ```

<!--
私はそこでstackのdocker integrationと（前の発表でもlotzさんが取り上げられた）spockを使って、さささっとそのmockサーバーを作ったんですが、

やっぱりですね、依存しているlibgmpやzlibのバージョンなどで一切悩む必要がなく、すんなりいけました。
開発環境だけで、実際に動かす環境向けの実行ファイルができちゃうんですね。
当然使うのはいつものstackコマンドです。
ビルドできたらあとはscpコマンドでアップロードするだけです。
-->

# Case study

Demo

[igrep/stack-docker-sample](https:/gitlab.com/igrep/stack-docker-sample)

<!--
今回は、ちょうどこのケースに近いデモを用意しました。
同じくCentOS 6が動いている、私のVPSに、spockで作った簡単なwebアプリをインストールして実行してみます。
-->

# Case study

(o˘◡˘o) My impression

- (\*´∀｀\*)ﾉ Comfortable:
    - I did't have to install anything except the built app.
- (´∪\`\*) The tiny application didn't need even CI!
    - All was done on my development machine.
- (x\_x;) Initial build takes a long time...
    - (;\^ω\^) Haskell was not good for tiny apps!

<!--
やってみた感想です。

第一に、楽チンでした。
サーバーにですね、ビルドした実行ファイル自体以外なにもインストールする必要がないんですね！
今回のように非常に小さなアプリケーションでは、CIすらセットアップしなくてよいので、
本当に全て私の開発環境だけで完結しました。

ただしですね、最初のビルドに超実行がかかっちゃうんですねー、やっぱりHaskellだから。
そもそもこういう小さなアプリをHaskellで組むと最初がしんどかったです。
しかももうそのアプリほぼ使ってないしw

まぁ、どうしてもHaskell使いたかったんです。
ボスがなに使ってもいいよ、って言ったんでw
-->

# (\^-\^) The Good News

- Available on Docker for Mac OS X, not only Linux!

<!--
ここで、stackのdocker integrationの実行環境に関して、よいお知らせと悪いお知らせがあります！

まずよいお知らせ！
stackのdocker integrationは、最近でたDocker for Mac OS Xで動きます！
Linux上だけではありません！
-->

# (x\_x;) The Bad News

- boot2docker is NOT recommended.
    - VirtualBox's shared folder is too slow!
- **Unavailable** on Docker for Windows...
    - See [this issue](https://github.com/commercialhaskell/stack/issues/2421)

<!--
続いて悪いお知らせ！

Docker for Mac OS Xより前から使われていた、boot2dockerは推奨されていません！
boot2dockerが、Dockerの共有ボリュームを実装するのに使っている、VirtualBoxの共有フォルダーが遅すぎて、
stackのdocker integrationでは使い物にならないそうです！

それから、さっきMacの話が出たのでお察しのかたもいらっしゃるかもしれませんが、
Docker for Windowsでは動かないそうです！
なんか知らんけど即落ちてしまうそうです！
-->

# Current limitation

- Use on Linux or Mac OS X!
    - (;\^ω\^) Sorry Windows users!
    - Use the other VMs to run Linux!

<!--
以上の実行環境のお話についてまとめますと、

stackのdocker integrationは
Macか、Linux上で使ってください！
Windowsユーザーのみなさんごめんなさい！
素直にVM上でLinuxを動かしましょう！
-->

# Conclusion

Stack's Docker integration enables:

- To build production-ready executables  
  **as easily as you use `stack` command as usual**. (\^-\^)
    - Only with your machine and scp!
- But Haskell is too slow to compile tiny apps... (ﾟ◇ﾟ;)
    - Especially compiling dependencies!

<!--
それではまとめです。

stackのdocker integrationを使うと、
本番で動く実行ファイルが、いつものstackコマンドを使うのと同じぐらい簡単にできちゃいます！
CIとか気にしないのであれば、開発環境とscpコマンド一発でできちゃいます！

ですが、それぐらい単純なアプリケーションであれば、Haskellを使うと、特に初回の依存関係のコンパイルが遅くて割高に感じてしまうかもしれません。
覚悟しましょう。
-->
