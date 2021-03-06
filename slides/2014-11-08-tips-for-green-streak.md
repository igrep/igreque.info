---
title: 緑化のコツ
author: 山本悠滋
date: 2014-11-08 Yokohama.rb #50

---

# 前口上

※タイトルからお察しの通り、「自分を変えた1冊」の紹介ではありません...

- 「とはいえ、必ずしもこのテーマに従う必要はありません。」

# こんにちは！

すでに親しい方も多いですが...

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 25歳♂
- [Sansan](http://www.sansan.com/)という会社でRailsを触ってます。
- [Yokohama.rb](http://yokohamarb.doorkeeper.jp/)のRubyKaja 2014に選ばれました。ありがとう！
- [Haskellの勉強会](http://connpass.com/series/754/)をツキイチでやってます！
- 打倒RSpecを目指して鋭意開発中！
    - ですが今日はその話は（ほぼ）しません！

# 今日話すこと

いきなりなんですが...

- 打倒RSpecという目標のもと、[CrispyというTest Doubleのためのgem](https://github.com/igrep/crispy)を作っています。
- つい先日v0.2.0をリリースしました！
    - RSpecの`expect_any_instance_of`や`stub_const`相当のことができるようになりました！

# 今日話すこと

そんなにしてたらここまで続けられました！

- [![GitHub Contributions](/imgs/2014-11-08-github-contributions.png)](https://github.com/igrep)

# 今日話すこと

↓こんな風に長く続けるコツをお話しします。

[![GitHub Contributions](/imgs/2014-11-08-github-contributions.png)](https://github.com/igrep)

# コツ1: 道具にこだわれ

いつでもどこでもプログラミングできるよう、できるだけ軽い環境を用意しましょう。

# コツ1: 道具にこだわれ

条件

- できるだけ軽量で大き目のタブレット
    - 10インチのほうが画面の情報量が多くてよいかと。
- Windows 8タブレットのほうがおすすめ
    - Gitやエディタを調達しやすいので。
- タッチパネルで扱いやすいアプリを選びましょう。

# コツ1: 道具にこだわれ

私の場合...

- マシン：
<a href="https://www.amazon.co.jp/gp/product/B00GSJ1EXY/ref=as_li_ss_tl?ie=UTF8&amp;camp=247&amp;creative=7399&amp;creativeASIN=B00GSJ1EXY&amp;linkCode=as2&amp;tag=poe02-22">ASUS TransBook T100TA</a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=poe02-22&amp;l=as2&amp;o=9&amp;a=B00GSJ1EXY" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<a href="https://www.amazon.co.jp/gp/product/B00GSJ1EXY/ref=as_li_ss_il?ie=UTF8&amp;camp=247&amp;creative=7399&amp;creativeASIN=B00GSJ1EXY&amp;linkCode=as2&amp;tag=poe02-22"><img border="0" src="https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&amp;ASIN=B00GSJ1EXY&amp;Format=_SL250_&amp;ID=AsinImage&amp;MarketPlace=JP&amp;ServiceVersion=20070822&amp;WS=1&amp;tag=poe02-22" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=poe02-22&amp;l=as2&amp;o=9&amp;a=B00GSJ1EXY" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

# コツ1: 道具にこだわれ

私の場合...

- GitHub for Windows
- [![GitHub for Windows Web Site](/imgs/2014-11-08-github-for-windows.png)](https://windows.github.com/)

# コツ1: 道具にこだわれ

GitHub for Windows

- できることが少ない分、小さい画面でも使いやすい。
- ブランチ切ってひたすらコミット繰り返すだけなら充分だし楽。
- できないことはCLIのgitで。

# コツ1: 道具にこだわれ

フルキーボード

- Windows 8だと設定を変えれば標準で！
- <img src="/imgs/2014-11-08-windows-full-keyboard.png" alt="Windows 8標準のフルキーボード" width="683" height="190" />

# コツ1: 道具にこだわれ

フルキーボード

- ちなみに。Androidもサードパーティ製のものが。
- [![日本語フルキーボード For Tablet](/imgs/2014-11-08-android-full-keyboard.png)](https://play.google.com/store/apps/details?id=info.repy.android.FullKeyboard)
- iPadは知らん。

# コツ1: 道具にこだわれ

安定のGVim

<a title="By User:D0ktorz [GPL (http://www.gnu.org/licenses/gpl.html)], via Wikimedia Commons" href="http://commons.wikimedia.org/wiki/File%3AVimlogo.svg"><img width="512" alt="Vimlogo" src="//upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Vimlogo.svg/512px-Vimlogo.svg.png"/></a>


# コツ1: 道具にこだわれ

安定のGVim

- 工夫すればLinuxなどと設定やプラグインの共有もできます。
- タッチパネルでもスクロールもカーソル移動もできちゃう！
- 外部コマンドを即起動！
- 他のエディタでもだいたいそうでしょうけどね！

# コツ2: コミットを小分けに

ある日のcrispyのコミットログ

- [![ある日の私のコミットログ](/imgs/2014-11-08-crispy-compare-class-spy-crop.png)](/imgs/2014-11-08-crispy-compare-class-spy.png)

# コツ2: コミットを小分けに

1日1コミットに抑えるために。

- `git add -p`とか
- `fugitive.vim`の`Gdiff`コマンドとかはもちろん
- お手軽な方法として、一時的にundoしたり編集した箇所を削除してからコミット、という方法も！

# コツ2: コミットを小分けに

複数のファイルを並行して編集する。

# コツ3: 明日のコミットを今日作ろう

- 朝電車に乗ったら最初に昨日の分をコミット。
- 「複数のファイルを並行して編集」することで「貯金」を作る。
- コミットが細かすぎて説明しにくいものにならないように！
    - コミットメッセージが書きにくくなり、履歴がわかりづらくなる！

# コツ4: 最終兵器

- `GIT_AUTHOR_DATE` または `GIT_COMMIT_DATE` でググってください。
- これであなたも数分で真緑にできます（多分）。
- 良い子はマネしないでね！
    - 大事なのは緑化そのものよりも習慣づくり。

# 効能

- 土日の趣味プログラミングも捗る！
- なんとなくコーディングしたくなる！
- ますますおうちに引きこもる！
- 1日1コミットにこだわるあまり、却って作業速度に悪影響が出ることも...。

# ちなみに

- [ハロウィンの日は緑ではなく黄色くなっていました。](http://syonx.hatenablog.com/entry/2014/10/31/235439)
- ↓（[よその人](https://github.com/syon/)ので恐縮ですが...）
- ![ハロウィン仕様の「Contributions」](/imgs/2014-11-08-github-halloween.png)
