% Haskell入門者LT会 ゲスト発表
% Yuji Yamamoto (山本悠滋)
% 2017-08-28

# はじめまして！ (\^-\^)

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 = プリキュア歴 = 約5年。
- igrep.elというEmacsプラグインがありますが無関係です！

# はじめまして！ (\^-\^)

- 今年3月末から[日本Haskellユーザーグループ](https://haskell.jp/)というコミュニティーグループを立ち上げ、その発起人の一人として活動しております。
    - 愛称: Haskell-jp
- 詳しくは後ほどしゃべりますが、日本にHaskellを広めるためにいろいろやっております。

# 近況 + 宣伝 m(\_ \_)m

- 生まれて初めてプロの編集さんと仕事しました。
- [エンジニアHub](https://employment.en-japan.com/engineerhub/)というウェブメディアです。

# 近況 + 宣伝 m(\_ \_)m

「[Haskellらしさって？「型」と「関数」の基本を解説！【第二言語としてのHaskell】](https://employment.en-japan.com/engineerhub/entry/2017/08/25/110000)」  
というやさしいHaskellの入門となっております。

![](/imgs/2017-08-28-haskell-intro.png)

# と、いうわけで今日のテーマ！！！

<div class="takahashiLike incremental">
Haskell-jpらしさって？  
「目的」と「活動」のすべてを解説！  
【プログラミング言語コミュニティーとしてのHaskell-jp】
</div>

# と、いうわけで今日のテーマ！！！

- Haskell-jpの紹介として、現在進行中の活動を総ざらいします。
- 活発なものもそうでないものも紹介するので、訓練されたHaskell-jpの人もそうでない人も知らないものがあるかもね！

# Agenda

- 目的
- 活動
    - [Slackチーム](https://haskell-jp.slackarchive.io/)
    - [Reddit](https://www.reddit.com/r/haskell_jp/)
    - [Haskell-jpブログ](https://haskell.jp/blog/)
    - [Haskell-jpもくもく会](https://haskell-jp.connpass.com/)
    - [Haskell-jp wiki](https://wiki.haskell.jp/)
    - [Haskell-jp TODOリスト](https://trello.com/b/GfAyczPt/haskell-jp)
    - [Haskellレシピ集](https://github.com/haskell-jp/recipe-collection)
    - [Haskell Antenna](https://haskell.jp/antenna/)
    - [相互リンク集](https://haskell.jp/blog/posts/links.html)
- そのほか、特にやる気はあること

# 目的

- 日本にHaskellを普及させる
- 日本を代表するHaskellのユーザーグループとなる
    - 国内外のHaskellコミュニティーをはじめ、IT業界における広い認知を得ること

# [Slackチーム](https://haskell-jp.slackarchive.io/)

- いろいろしゃべったり質問したり、フィードを流したりしてます
- リンク先は[SlackArchive](http://slackarchive.io/)を利用した発言ログ
- 登録は[こちら](https://haskell.jp/signin-slack.html)から。

# [Slackチーム](https://haskell-jp.slackarchive.io/)

運用ルール

- 質問は\#questionsか\#generalで。
    - \#generalで質問を許可しているのは、慌ててやってきた人が質問した場合の救済策
    - たらい回しにするやりとりを避けたい
- ネチケット（多分死語）は守りましょう。
- チャンネル作りはご自由に。

# [Slackチーム](https://haskell-jp.slackarchive.io/)

おすすめチャンネル

- questions: 軽い気持ちの質問チャンネル
- questions-feed: teratail・Stackoverflowなどの質問が流れます
    - ちょっと更新頻度が高すぎるかもですが...。
- event-announcement: イベントの募集やどこそこで登壇する、といった情報を配信
    - 自動化したい...。

# [Reddit](https://www.reddit.com/r/haskell_jp/)

作った背景:

- Slackだとクローズドで、生み出した情報とかが再利用できないよね。
    - 検索にもひっかからないし、
    - SlackArchiveは微妙だし。

# [Reddit](https://www.reddit.com/r/haskell_jp/)

- スレッドがDISQUSみたいなツリー上の構造になることもあり、込み入った議論や相談に便利。
- もちろん検索エンジンもインデックスしてくれる。
- 実は**今はSlackよりこちらを推奨**しています。
- Slackチームのreddit-haskell-jpのチャンネルにも投稿が流れます。

# [Haskell-jpブログ](https://haskell.jp/blog/)

- 〆(ﾟ\_ﾟ\*)  
  広くHaskellに関する記事なら誰でも投稿できる。
- **執筆者常時募集**。
- [こちらのリポジトリー](https://github.com/haskell-jp/blog)にPull requestを送ってください。
- このイベントのレポートなんてこれまでなかったタイプの記事なんでちょうどいいでしょう！

# [Haskell-jpもくもく会](https://haskell-jp.connpass.com/)

- (\*´Д\`)  
  「Haskellに関する作業をもくもくとやったり、希望者でLTを行ったりするゆるい会」
- 弊ユーザーグループ設立のきっかけとなった[Haskellもくもく会](https://haskellmokumoku.connpass.com/)が前身。
    - Haskellもくもく会から数えて次回で46回目！
- 初心者から上級者まで好き勝手やっております。

# [Haskell-jpもくもく会](https://haskell-jp.connpass.com/)

- 重要: [次回は9月10日（日）](https://haskell-jp.connpass.com/event/64567/)
- (;\^ω\^)  
  学生枠を設けてますが、今回に限って学生枠が集まりすぎてうれしい悲鳴を上げています。

# [Haskell-jp wiki](https://wiki.haskell.jp/)

- いろいろ書いているWikiです！
- [gitit](https://github.com/jgm/gitit)というHaskell製のWikiエンジンでできています。
- GitHubアカウントがあれば誰でも編集できます。

# [Haskell-jp wiki](https://wiki.haskell.jp/)

おすすめのページ:

- [Haskellに関する日本語のリンク集](https://wiki.haskell.jp/Links)
- [データ構造列伝](https://wiki.haskell.jp/%E3%83%87%E3%83%BC%E3%82%BF%E6%A7%8B%E9%80%A0%E5%88%97%E4%BC%9D)

# [Haskell-jp TODOリスト](https://trello.com/b/GfAyczPt/haskell-jp)

- パブリックなTrelloのボード。
    - Haskell-jpのやりたいことが割と見えます。
- 要望がある場合Slackなどで提案すると、多分優しい誰かがBacklogに追加してくれます。

# [Haskell-jp TODOリスト](https://trello.com/b/GfAyczPt/haskell-jp)

- 現状、権限を持った人以外コメント含め書き込みはできません。あしからず。
- 希望者は私なりSlackなりでご相談を。

# [Haskellレシピ集](https://github.com/haskell-jp/recipe-collection)

- 文字通りレシピ集
- あまり私は関わっていないのですが、どうも更新停止気味 （◞‸◟）

# [Haskell Antenna](https://haskell.jp/antenna/)

- [Haskell News](http://haskellnews.org/)にインスパイアされて作成。
- 超実験的。**運がよかったら見える**。
    - 作者の[\@lotz84氏](https://github.com/lotz84)個人のHerokuアカウント（無料枠）で動いているので...。

# [Haskell Antenna](https://haskell.jp/antenna/)

- [こちらのリポジトリー](https://github.com/haskell-jp/antenna)にPull requestを送れば情報源を増やすこともできます。

# [相互リンク集](https://haskell.jp/blog/posts/links.html)

- Haskell好きな人が、
- Haskellについて書いたWebサイトに、
    - （サイト全体の一部でOK）
- こんなバナー→ <img width="234" src="https://haskell.jp/img/supported-by-haskell-jp.svg" alt="Supported By Haskell-jp."> を張ってもらい、
- それを一覧にしたもの

# そのほか、特にやる気はあること

- 入門コンテンツ
    - 鋭意開発中。まだ共有してなくてすまん。
    - 今後ブログと並ぶ大きなコンテンツの一つとしたい。

# そのほか、特にやる気はあること

- 法人化
    - 「Haskell-jp」としてはゆるめのつながりでありたい
    - でも、運営委員会的な組織は多分遅かれ速かれ必要
    - お金の管理とか、目標とか責任とかを明確にするため

# まとめ

- Haskell-jpの一つの大きな役目は、haskell.jpというドメインを通じ、場を提供すること
    - ブログとか、アンテナとか、Wikiとか。
    - haskell.jpを利用したコンテンツはほかにもあっていいと思うのでどんどんどうぞ！
- 何かあればRedditやSlack、GitHubのIssueなどでご連絡ください！
- 今後とも、Haskell-jpをよろしくお願いします hask(\_ \_)eller
