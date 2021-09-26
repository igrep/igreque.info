---
title: slack-log の紹介
author: YAMAMOTO Yuji (山本悠滋)
date:  2021-11-07 Haskell Day 2021

---

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約9年。
- 趣味Haskeller兼仕事TypeScripter @ [IIJ-II](https://www.iij-ii.co.jp/)
- igrep.elというEmacsプラグインがありますが無関係です！

# 📝今日話すこと

- 「Haskell-jp」として開発しているHaskell製アプリケーション「slack-log」を紹介します
    - 開発の背景や、
    - 機能の紹介、
    - 細かい実装などを、淡々と。
        - 目新しいことは何もしていないので、過度な期待は禁物
- 🙏Haskellでこんな風に普通のCLIアプリが作られているんだ、ということが伝われば！

# 🤖slack-logとは？

[これ](https://haskell.jp/slack-log/)👇を自動で作るコマンドです！

- <img src="/imgs/2021-11-07-haskell-day-2021-slack-log/slack-log-index.png" />

# 🤖slack-logとは？（続き）

- SlackのWeb APIを利用して、Slackでやりとりしたメッセージの内容を保存するアプリケーション
- 保存したJSONファイルを、設定したテンプレートでHTMLに変換することもできる
- 現在は[Haskell-jpのSlack Workspace](https://haskell.jp/signin-slack.html)のログを毎日インクリメンタルに保存している
    - <https://haskell.jp/slack-log/>にて、生成したHTMLが閲覧できる

# なぜ作った？

- 🔥Slackは無料プランでは、Workspace全体のメッセージが合計1万件を超えてしまうと、古いメッセージから閲覧できなくなってしまう！
- 💸無償のオンラインコミュニティーとして、賄うのは無理
    - 😰まぁ、本来Slackをそういう用途に使うなよ、という話ではあるのですが...
- 🗃でも、やりとりされた情報には有益なものも多いので、ちゃんと保存して公開したい

# 😤slack-logのいいところ

同じ目的である[Slack Archive](https://github.com/dutchcoders/slackarchive)に対して:

- 保存のために常駐するサーバーが要らない
    - Slack ArchiveはbotとしてWorkspaceに所属する必要がある
- 変換したHTMLをそのままGitHub Pagesなどでお気軽に公開できる
- 今でもゆっくり開発が続いている
    - Slack Archiveの最後のコミットはもう3年前！

# 😕slack-logのイマイチなところ

- SlackのWeb APIを使用しているので、APIの利用回数の制限を受ける
    - Haskell-jpのように ~~過疎気味で~~ メッセージが少ないWorkspaceなら全く問題はないが、超頻繁にやりとりされているWorkspaceだと収集が追いつかないかも💦
- 完成度が低い
    - Slack Web APIが返すJSONの、最小限のフィールドしか保存できてない
        - Emojiリアクションなどは保存できてない
    - ドキュメントがない

# ✍️使い方

- ⚠️予め設定ファイルを記述した上で、
- `slack-log save`:
    - ⏬設定したチャンネルのメッセージをJSONファイルとして保存してHTMLを生成
- `slack-log generate-html`:
    - 🎨設定したテンプレートでHTMLを生成し直す

# 🗼実装概要

[cabalファイル](https://github.com/haskell-jp/slack-log/blob/3280a8dd6accf9ff8c1104e55f9662cb8f774a26/slack-log.cabal)を見てみよう

- （よくあるHaskell製アプリケーションと同様）ライブラリーと実行ファイルとテストが一つずつ
- （「使い方」で紹介した）[`slack-log`という名前の実行ファイルのソースコードは`app`にあって、その中の`Main.hs`に`main`関数がある](https://github.com/haskell-jp/slack-log/blob/3280a8dd6accf9ff8c1104e55f9662cb8f774a26/slack-log.cabal#L71-L77)
    - `Main.hs`を先頭から読んで、最初にSlackのWeb APIを呼び出すところまで

# ⚙️実装解説: Main.hs

まずは[`app/Main.hs`](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs)を見てみよう:

```haskell
import UI.Butcher.Monadic ({- ... 省略 ... -})

main :: IO ()
main = do
  -- ... 省略 ...
  mainFromCmdParserWithHelpDesc $ \helpDesc -> do
    addHelpCommand helpDesc
    addCmd "save" $ addCmdImpl saveCmd
    addCmd "generate-html" $ do
      -- ... 省略 ...
      addCmdImpl $ generateHtmlCmd onlyIndex
    addCmd "paginate-json" $ addCmdImpl paginateJsonCmd
```

# ⚙️実装解説: Main.hs （続き）

- [butcher](https://hackage.haskell.org/package/butcher)というパッケージでコマンドライン引数のパース
    - コマンドラインオプションやサブコマンドを検出したり、
    - サブコマンドによって使用できるオプションを切り替えたり
    - helpを作成したり。

# ⚙️実装解説: `slack-log save`

この行で、サブコマンド`save`を追加

```haskell
addCmd "save" $ addCmdImpl saveCmd
```

- 💁‍♂`slack-log save`コマンドはここで設定
- `saveCmd`という関数が実際に実行する`IO`アクション

# ⚙️実装解説: `saveCmd`関数（概要）

3つのパート:

1. [設定の読み込み](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L107-L111)
1. [保存](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L112-L124)
    - SlackのWeb APIを呼ぶのはここ！
1. [HTMLへの変換](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L126-L136)

<!--
1. 設定の読み込み
    1. slack-log.yamlの読み込み
    1. `WorkspaceInfo`の読み込み
1. 保存
    1. ユーザー一覧の保存
    1. チャンネルのメッセージの保存
    1. リプライの保存
1. HTMLへの変換
1. index.html の生成
-->

# ⚙️ `saveCmd`関数（設定の読み込み その1）

```haskell
saveCmd = do
  config <- Yaml.decodeFileThrow "slack-log.yaml"
  -- ... --
```

- [yaml](https://hackage.haskell.org/package/yaml)パッケージを使って、slack-log.yamlというファイルから大半の設定を取り出す

# ⚙️ `saveCmd`関数（設定の読み込み その2）

```haskell
saveCmd = do
  -- ... --
  apiConfig <- Slack.mkSlackConfig . slackApiToken =<< failWhenLeft =<< decodeEnv
  -- ... --
```

- 環境変数からSlackのWeb APIの利用に必要なsecretを取得
- [envy](https://hackage.haskell.org/package/envy)というパッケージを使用している
    - 環境変数の値を組み合わせて欲しい型の値を作る、という処理を簡単に

# ⚙️ `saveCmd`関数（設定の読み込み その3）

```haskell
ws <- loadWorkspaceInfo config "json"
```

- slack-log.yamlにある設定項目のうち、HTMLの生成に必要な設定項目を絞って抽出・加工したり、HTMLのテンプレートのコンパイルをしている
    - テンプレートエンジンには[mustache](https://hackage.haskell.org/package/mustache)を使っている

# ⚙️ `saveCmd`関数（ユーザー一覧の保存）

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... 他にも apiConfig に依存した処理
```

- `saveUsersList`関数でSlackのWeb APIを呼び出して、Workspaceにいるすべてのユーザーの情報を取得・保存
    - SlackのWeb APIが返すメッセージには、ユーザーのIDしか含まれていないので、スクリーンネームをHTMLに書き出すために必要
- SlackのWeb API呼び出しの例として深掘りします

# ⚙️ `saveUsersList`関数

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... result からユーザーの一覧を取り出して保存
```

- `Slack.usersList`という関数が実際にSlackのWeb APIを呼ぶ関数
    - Haskellの「qualified import」という機能を使っている関係で`Slack.usersList`という名前で参照されているが、正式には`usersList`という名前

# 📝`ReaderT`型・`runReaderT`関数 (1)

先に結論:

- `runReader`関数で渡した引数を、`do`の中に書いたあっちこっちの関数に自動的に渡してくれる

# 📝`ReaderT`型・`runReaderT`関数 (2)

今回紹介した箇所では次のような型に:

```haskell
runReaderT    :: ReaderT r IO a
                   -> r -> IO a
usersList     :: ReaderT r IO (Response ListRsp)
saveUsersList :: ReaderT r IO ()
```

- `runReaderT`は`r`（slack-logでは`SlackConfig`が該当）を受け取ることで、「`ReaderT r IO`」という（変な名前の）`Monad`をただの`IO`に変換する

# 📝`ReaderT`型・`runReaderT`関数 (3)

今回紹介した箇所では次のような型に:

```haskell
runReaderT    :: ReaderT r IO a
                   -> r -> IO a
usersList     :: ReaderT r IO (Response ListRsp)
saveUsersList :: ReaderT r IO ()
```

- `usersList`を含め、SlackのAPIを実行する関数は、`ReaderT r IO`という`Monad`の関数になっている
    - `saveUsersList`は`usersList`を呼ぶため、同様に`ReaderT r IO`という`Monad`に
    - ℹ️大雑把な原則: とある`Monad`の関数を呼ぶには呼び出し元の関数も同じ`Monad`の関数である必要がある

<!--
        - `IO`が典型的なそれ
-->

# 📝`ReaderT`とは？

- Monad Transformerの一種
    - 複数の`Monad`の機能を一つの`do`記法で使えるよう、合成した`Monad`を作る
        - Ref. [Maybe と IO を一緒に使いたくなったら - ryota-ka's blog](https://ryota-ka.hatenablog.com/entry/2018/05/26/193220)
        - 「`ReaderT r IO`」の場合「`Reader r`」の機能と`IO`の機能が同時に使える
- 💁‍♂Tips: Monadを理解するときは、具体的な各種のMonadの使い方を理解すること
    - 個別のMonadを知ることで、組み合わせたMonad Transformerも理解できる
    - `IO`はおなじみ。入出力を始めなんでもできる。では「`Reader r`」とは？

<!--
- Monadを理解するときは「Monad」というコンセプトがなんなのかを正確に理解することより、各種の具体的なMonadの使い方を理解すること
-->

# 📝では`Reader`とは？

実は「`Reader r a`」は「`r -> a`」と等価な（`newtype`した）もの:

<!--
実は「Reader」というのは、「Reader r a」と書いたとき、
型「r」の値を受け取って、結果となる型「a」の値を返す関数と等価なものです
-->

- ➡️ただの関数をMonadとして`do`で扱えるようにしただけ！
- 「`Reader r`」はどうやって関数をMonadに？
    - 💁‍♂Tips: あるMonadのインスタンスを理解するときは、`do`記法で使ったとき何が起こるか・何ができるかを知るといい

<!--
ここでは、`Reader`を`do`記法で使った場合に何が起こるのか見ることで理解してみましょう。
-->

# 📝`Reader`の`do`（を使わなかった場合）

例: 「`Reader r`」の`do`を使う前のただの関数

```haskell
someFunc :: Arg -> [Result]
someFunc arg =
  let r1 = f1 arg
      r2 = f2 arg
      r3 = f3 arg
   in r1 ++ r2 ++ r3

-- 使う時は単純にこう👇
someFunc arg
```

<!--
まずは、`Reader r`の`do`記法を使わないで、ただの関数を定義した例です。
`arg`という名前の引数を、関数`fワン`, `fツー`, `fスリー`それぞれに渡していますね。
使う時も、単純に`arg`を渡すだけです。
-->

# 📝`Reader`の`do`（を使った場合）

例: 「`Reader r`」の`do`を使った関数

```haskell
someFunc :: Reader Arg [Result]
someFunc = do
  r1 <- f1
  r2 <- f2
  r3 <- f3
  return $ r1 ++ r2 ++ r3

-- 使う時は runReader を使ってこう👇
runReader someFunc arg
```

<!--
そしてこれが、`Reader r`の`do`記法を使って関数を定義した例です。
なんとここでは、`arg`という引数がなく、
関数`fワン`, `fツー`, `fスリー`も、引数`arg`を渡さないで使っているように見えます。
ところが使う時には、`runReader`関数を使って`arg`を渡していますね。
-->

- 🔆`arg`が、`runReader`関数を呼ぶときに**一度だけ**渡せば良くなってる！

# 📝`Reader`が`do`でしていること

- `runReader`関数で渡した引数`arg`を、あっちこっちの関数に自動的に渡してくれる。それだけ！
    - 実際のところ、手で`arg`と書いて渡せば良い話でもある。見かけの問題
    - 内部DSLを作る場合など「見かけの問題」が意外と馬鹿にできないケースも（今回は割愛！）

# 👀改めて`usersList`関数

```haskell
usersList :: ReaderT SlackConfig IO (Response ListRsp)
```

👆は結局のところ👇と実質同じ

```haskell
usersList :: SlackConfig -> IO (Response ListRsp)
```

<!--
ここで振り返って、slack-logで使用しているSlack Web APIを呼ぶ関数
usersList関数を見直してください。

usersList関数は、`ReaderT SlackConfig IO`というMonadの関数になっているのですが、
これは実際のところ、`SlackConfig`を受け取って`IO` Monadで`Response`を返す関数と、
事実上何も変わりません。
-->

# 🤔なぜ`ReaderT`を使っているのか

- `usersList`関数のような、SlackのAPIをたくさん呼ぶアプリケーションを書くときに`SlackConfig`をあちこちの関数に逐一渡さなくて良くなる
    - 俗に言う「バケツリレー」をしなくてよくなる
        - 余談: <!-- 「バケツリレー」という言葉を聞いてピンと来た人がいらっしゃるかも知れませんが --> Reactの「Context」と利用目的が似てる
    - slack-logもそうしたアプリケーションなので、`ReaderT SlackConfig IO`が利用できる箇所では利用
- `ReaderT r IO`は、数あるMonad Transformerの用途の中で最も知られている、「`ReaderT`パターン」を実現するのに用いられる
    - `usersList`を始めslack-webパッケージの各種APIを呼ぶための関数も「`ReaderT`パターン」で使いやすくなるよう型付けされていると思われる
        - 「`ReaderT`パターン」については割愛！

# 😕私見: 本当に`ReaderT`を使うべきか？

<!--
で、ちょっと話がずれてしまうんですが、slack-webパッケージが、本当に`ReaderT`を使うべきなのか、
ということについて、私見を述べさせてください。
-->

- `ReaderT SlackConfig IO a`と`SlackConfig -> IO a`間の相互変換は充分に簡単なので、初めて使う人が混乱しないよう、敢えてライブラリー側で`ReaderT`の利用を強要しないで欲しい
- 実際の`usersList`の型:

  ```haskell
  usersList :: (MonadReader env m, HasManager env, HasToken env, MonadIO m)
    => m (Response ListRsp)
  ```
- 超単純化した`usersList`の型:

  ```haskell
   usersList :: SlackConfig -> IO (Response ListRsp)
   ```

# ⚙️ ユーザー一覧の保存 まとめ

<!--
ちょっと脱線してしまいましたが、「ユーザーの一覧」を保存する処理についてまとめます。
ここでは、ご覧のとおり`ReaderT`型という、少し難しい型が出てきました。
-->

「ユーザー一覧の保存」をしている箇所（再掲）

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... ほかにも apiConfig に依存した処理
```

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... result からユーザーの一覧を取り出して保存
```

# ⚙️ ユーザー一覧の保存 まとめ（続き1）

<!--
この、`ReaderT`型のおかげで、`saveUsersList`関数などを呼ぶ前に、
`runReaderT`関数に一度だけ`apiConfig`を渡せば、`saveUsersList`関数をはじめ、
`apiConfig`を引数として受け取る関数に自動的に`apiConfig`を渡せるようになるのでした。
結果、上のコードが下のコードのように変わって、
-->

`runReaderT`や`ReaderT`によって

```haskell
do
  saveUsersList apiConfig
  -- ... ほかにも apiConfig に依存した処理
```

が、

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... ほかにも apiConfig に依存した処理
```

になって

# ⚙️ ユーザー一覧の保存 まとめ（続き2）

<!--
saveUsersList関数は`apiConfig`を直接引数として受け取ることなくslack-webのusersList関数
をよべるようになるのでした。
-->

`runReaderT`や`ReaderT`によって

```haskell
saveUsersList :: Slack.SlackConfig -> IO ()
saveUsersList apiConfig = do
  result <- Slack.usersList apiConfig
  -- ... result からユーザーの一覧を取り出して保存
```

が、

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... result からユーザーの一覧を取り出して保存
```

になる！

# 今後の展望

- アプリケーションとしてリリース
    - 現在は保存したメッセージとアプリケーション本体のソースが一つのリポジトリーに入ってしまっているので分離
    - 実行ファイルをGitHub Releasesにアップロード
- リファクタリングするなら:
    - rioパッケージを使う？
        - `ReaderT`パターンがより適用しやすくなる！
    - pathパッケージを使う？
        - 絶対パスと相対パス、ディレクトリーへのパスかファイルへのパスか、を型レベルで区別

# まとめ

- slack-logは、名前のとおりSlackのメッセージを保存するアプリケーション
    - GitHub Pagesなどで閲覧できるよう、HTMLとして出力する機能もあり
- butcherというパッケージを使うことで、サブコマンドやコマンドラインオプションの処理を簡単に実現している
- slack-webパッケージでSlackのWeb APIを利用する際は、`ReaderT` Monad Transformerの使い方を抑えておこう！
    - とりあえず使うだけなら都度``(`runReaderT` apiConfig) someApiFunc``というイディオムを使えば良い
- 👍Contribution Welcome!
