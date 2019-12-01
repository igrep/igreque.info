---
title: Service WorkerとFacebookに遊ばれてました
author: 山本悠滋
date: 2015-10-01 表参道.rb #5

---

# こんにちは！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 26歳♂
- 最近はRubyよりもJavaScriptに力を入れてます。
- [Node学園](http://nodejs.connpass.com/)たのしいれす (\^q\^)

# Service Workerの話をします！

<div class="takahashiLike incremental">
使ったことある人ー (\^ω\^)ノ
</div>

# (\^o\^)ノ&lt;(はーい!!)

- ![](/imgs/2015-09-25-service-workers.png)

# Facebookでーす！

- AndroidのChrome版FacebookでPush通知を実装するのに使ってるっぽい！
    - [Google Chrome Mobile Users Can Now Get Facebook Push Notifications](http://www.adweek.com/socialtimes/google-chrome-mobile-facebook-push-notifications/626731)

# ChromeからPush通知？

- できるんです。そうService Workerならね。

# なにするもの？

- いわゆるHTML 5的に新しく生まれ**ている（仕様策定中）**、ブラウザのJavaScriptから使える新しい機能。
- 役割は大きく2つ。
    - ブラウザ内臓のローカルプロキシ
    - ブラウザ版daemon的な奴

# なにするもの？

ブラウザ内臓のローカルプロキシ

- Webページを閉じててもバックグラウンドで動いて
    - ブラウザに成り代わってページをダウンロードしたり
    - オフラインでもアクセスできるようキャッシュしたり。

# なにするもの？

ブラウザ内臓のローカルプロキシ

- Eightで使うなら
    - 全件同期！！！！！！
    - ログインと同時にサーバーからまるっと落としてIndexedDBに保存！
        - アプリ版でやってることがブラウザでも！
    - もちろん、普通に画像とかをキャッシュしておくもよし。

# なにするもの？

ブラウザ版daemon的な奴

- 文字通り、バックグラウンドで動く奴。
    - Service WorkerのServiceはWindows ServiceのService!  
      (要出典)
- プッシュ通知を受け取ったり、設定した時間に何かしたりできる？

# 試してみたで: その1 Facebook

- 「ええやん！」が来るか試してみた。
- ![](/imgs/2015-09-25-facebook-notification.png)

<div class="incremental">
※ちなみに僕のFacebookの言語設定は「日本語（関西弁）」やで。
</div>

# 試してみたで: その1 Facebook

- こうへん (´;ω;\`)
- PC版、Android版共に試すもうんともすんとも言わない
- しかもいつの間にかService Workerが死んでる...

# 試してみたで: その1 Facebook

と、思っていた時期が、私にもありました...。

- 「ええやん」にはそもそも通知がこない仕様らしい。
- 翌日になって「今日は○○の誕生日やで！」という~~どうでもいい~~通知がちゃんとやってきた。

<div class="incremental">
<small>よく考えたらアプリ版も同じ仕様だったような...</small>
</div>

# 試してみたで: その1 Facebook

- 疑ってごめんなさいFacebookさん 人(￣ω￣;)

# 試してみたで: その2 ちぃちゃいサンプル

そもそものモチベーション:

- 予め設定したタイミングで通知を出したい。
    - ただし、サーバーなしで。
- 作ったで: [igrep/sample-notification-service-worker](https://github.com/igrep/sample-notification-service-worker)

# 試してみたで: その2 ちぃちゃいサンプル

- よっしゃ動いた―ーーー
- ![](/imgs/2015-09-25-notified.png)
- やったーーー！ページ閉じても動くでー！

# 試してみたで: その2 ちぃちゃいサンプル

- さすがService Workerさんやー！
- ...あれ？

# 試してみたで: その2 ちぃちゃいサンプル

- 止まった... (´・ω・\`)
- また死んでる...

# 試してみたで: その2 ちぃちゃいサンプル

[W3Cおにいちゃん、なんでService Workerすぐ死んでしまうん？](http://www.w3.org/TR/service-workers/#service-worker-lifetime)

![](/imgs/2015-09-25-hotaru.jpg)

# 試してみたで: その2 ちぃちゃいサンプル

W3Cおにいちゃん:

>  The user agent **may terminate service workers at any time** it has no event to handle or detects abnormal operation such as infinite loops and tasks exceeding imposed time limits, if any, while handling the events.

# 試してみたで: その2 ちぃちゃいサンプル

要するに...

- 何もイベントを処理しなくなったり、
- なんか処理に時間がかかりすぎたりすると、
- 勝手にuser agent (つまりブラウザ)に殺されてしまうらしい...
    - 泣かぬなら 殺してしまえ Service Worker

# 試してみたで: その2 ちぃちゃいサンプル

[Service Workerの状態](chrome://inspect/#service-workers)をよく見てみたところ、

- Facebookはなにもイベントを起こさなかったから死んだっぽい。
    - ページを使用している間は死ななかった。
    - でもPush通知は死んでからもちゃんと届く。不思議。

# 試してみたで: その2 ちぃちゃいサンプル

[Service Workerの状態](chrome://inspect/#service-workers)をよく見てみたところ、

- 僕のケースは無限ループだったから死んだっぽい。
    - `setInterval`でえんえん通知を出す処理だったので...。

# まとめ

- 要するに僕がService Workerの仕様を勘違いしていたというタダのドジな話。
- 言い換えると僕が先進的すぎてService Workerが追いついていなかったということ。
- いずれにしても、夢が広がりんぐ！
- Eightアプリ版と全く同じことがブラウザ上で、しかもネットに繋がなくてもできる時代が来そう。
