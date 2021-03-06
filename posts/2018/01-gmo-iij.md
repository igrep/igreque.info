---
title: GMO -> (Age, IIJ)
author: Yuji Yamamoto
date: April 16, 2018
...
---

ご報告が遅くなりましたが、実は今年2月末をもちましてGMOフィナンシャルホールディングス株式会社を退職し、3月より株式会社インターネットイニシアティブに転職しておりました。  
<small>（一部知人には隠すようなことをしていてごめんなさい！）</small>

プリキュアで言えば2016年の「魔法つかいプリキュア！」がちょうど始まってから「キラキラ☆プリキュアアラモード」が終わるまでの2年間と、「HUGっと！プリキュア」が始まってからの1ヶ月分務めたことになります <small>（今回はちょうどプリキュアの移り変わり時期に転職することはできませんでした）</small>。

IIJに入社してからは3月にネットワーク開発本部に配属された後、現在はIIJ Innovation Institute (IIJ II)に出向しております。

# 経緯とか

きっかけは、 [\@kazu\_yamamoto](https://twitter.com/kazu_yamamoto)さんによるお誘いでした。  
kazuさんは私にとってある意味で私に最初にHaskellを教えた人の一人であり、[ブログ](http://d.hatena.ne.jp/kazu-yamamoto/)やスタートHaskell2という勉強会での発表を通して、私がHaskellを理解するのを強くサポートしていただけていました。  
それだけでも驚くべきことですが、加えてIIJ IIに新設される部署「技術開発室」の第1号のメンバーとして、しかもHaskellを使うということだったので、こんな面白そうなチャンスはほかにないだろうと思い、転職することといたしました。

# 前職の感想とか

最終出社日を終えてちょっとたった時点での感想をメモしておきます。

直属の上司を始め、いろいろな人によくしていただきました。  
前々職、Sansanに在籍していた頃の自分は、アルバイトから始めた契約社員だったということもあり、どうにも私個人の心理的な「身分の低さ」から抜け出すことができていなかったように思います。  
<small>（当時はここでは書きませんでしたが）</small>そうした気分を切り替えるためにも行った転職だったのです。  
その狙いは十二分に当たり、一正社員のエンジニアとして、[maneo](https://www.click-sec.com/corp/guide/maneo/index.html/#/corp/fund/index?listview=n)という新製品の新規開発や障害対応など、重要な仕事を多く任せていただけました。  
それとこれは完全に私個人の気分的なものですが、何より、メンバーとして前よりリスペクトされていたような気がします。

一方、Sansanの時とは異なり、暇な時期が続いてしまうことが多かったように思います。  
担当していた商品が比較的小規模で安定したものであったためでしょうか、初期の開発を終えてバグを直してからは、担当する商品も替わってやることが少なくなりました。  
その後はデータベースのアップグレードや障害対応などを除けば、私の仕事の大半はCI環境の再構築や、SVNからGitへの移行、Pythonでの簡単なデプロイツールの開発など、本番環境に直接関わらない仕事が大半でした。  
正直なところもっと普通のJavaアプリケーションを書きたかったですし、もっといろいろな問題に挑戦したかったです。

私がクリック<small>（旧社名が「GMOクリックホールディングス」であり、「GMOクリック証券」を運営しているため、今でもそう呼ぶ人は社内に多いです。呼びやすいですしね）</small>に入社した当初のモチベーションが「Haskellが栄えそうな（実際にはHaskellではないですが）、複雑な問題を解く」ことであったり、「金融取引システムらしい、速度と信頼性の両方が求められるシステムの開発」に挑戦することにあったため、それについては毎日もやもやしながら仕事してました。  
入社当初からそうした希望をもっと強く主張すべきだったかもしれません。

ともあれ、いずれにしても、暇な時期ももう少し待っていれば、脱Flashをはじめ大きな改修プロジェクトが待っていたので、それを前に辞めてしまったのは少し後ろ髪が引かれる思いです。  
とあるシステムの刷新にKotlinを使おうかと色めき立っていた、まさにそのときに声がかかったのでした。  
まぁ、その分暇だったおかげでこっそり趣味プロジェクトを進めたり、[Haskell-jp](https://haskell.jp/)の活動を進めたりと言ったことができたので、よい面でもありましたが😅。

ちなみに、私はクリックに所属していた頃、前述の「簡単なデプロイツール」を含め、いくつかの社内ツールをHaskellで書きました。  
👇のtweetでも書いたとおりです。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">速報：私のチームのメインのリポジトリーのmasterブランチに僅かながら <a href="https://twitter.com/hashtag/Haskell?src=hash&amp;ref_src=twsrc%5Etfw">#Haskell</a> のソースが入りました<br>実行環境を迂闊にインストールできない環境で、バッチファイルでやるには辛い自動化のために採用しました<br>みんなもGoを見習ってそう言うところを狙っていくといいと思います！</p>&mdash; Yuji Yamamoto: 山本悠滋 (@igrep) <a href="https://twitter.com/igrep/status/915514022220333057?ref_src=twsrc%5Etfw">2017年10月4日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

続くtweetで「私がいないとメンテできない、という事態に備えて、動作については可能な限り詳しいコメントを加えました」と述べたとおり、確かに私以外がメンテする事態には備えていましたが、今回は十分に時間があったため、大半のツールを私自身がJavaで書き直しました。  
今になって考えると、最初からJavaで書くのも十分アリだったでしょう😰 要件的には実行可能なUberJarを作れば解決できる問題だったのですが、当時はUberJarというものを知らなかったのです😜

結果として、前職であるGMOフィナンシャルホールディングスのGitHub Enterpriseには、**HaskellからJavaへほぼ一対一で翻訳されたソースが、数百行程度**ですができました。  
私が非常に気を遣って書いたため、本当にほとんどの部分が一対一に翻訳されています。  
もちろん（元）同僚たちが、再びHaskellに興味を持たれたときの参考資料とするためです！😤  
思えばたった数百行ながら、なんやかんや言ってここ一年間で一番Javaを集中して書いていた気がします😂。皮肉なもんですね。

JavaからHaskellに書き換えられたアプリケーション（あるいはその逆も？）は探せばちょくちょくあるかと思いますが、その場合、普通は設計から完全に作り直すかと思います。  
学習のために翻訳されているソースコードというのも珍しいでしょうし、気になる方は是非入社して覗いてみてください。

# 現在の心境とか

さて、IIJに入って早くも1ヶ月半が経ちました。  
有休消化期間中に食中毒にかかったおかげで初っぱなから2日間も休むという失態を犯してしまいましたが、今は毎日元気に働いています。

IIJは、正確に言うとIIJ IIは、IIJ本体よりずっと人数が少ないこともあってか、前職よりかなり静かな環境であるように感じます。  
前職や前々職の執務室ではほとんど常に誰かがしゃべっている状態が普通だったので、ちょっと新鮮でした。  
小さい頃から私は独り言が非常に多い人間で、前職でも前々職でもかなり迷惑をかけていたため、独り言がますます目立たないか心配でした。  
しかしここまで仕事してみた感じ、そういう静かな環境にいると自然と独り言の音量が下がるようで、IIJ IIに出向してからは音量・頻度ともにかなり抑えられているように感じます。  
もちろん、実際本当に迷惑をかけていないかは聞いてみないとわかりませんが...。  
特にハマっているときは依然としてひどくなる傾向にあるので、意識した方がいいですね...。

それから、これはIIJ全体に言える話だと思いますが、社内システムやそのドキュメントがめっちゃ丁寧に整備されていて感心しました。  
初めて入った私でもConfluenceのそれらしいページを読んでいけば、ほとんど周りの人に聞かなくても、プロキシやVPNなどもろもろのセットアップができました。  
欲を言えば新入社員がどこに目を通すべきかが一カ所にまとまっているとありがたかったですね<small>（おそらく人によってやることが違うので簡単ではないと思いますが）</small>。

いずれにしても、さすが長年日本のインターネットを支えている会社だけあってか、「我々自身のインフラを支えられないで、どうやってインターネットのインフラを支えるというんだ！」という強い気概を感じました。  
社内システムでもちゃんとHTTPSに対応しているところにも、高い真摯さを感じます。

残念ながら現状、まだ同じ部屋にいる人の顔と名前がほぼ一致せず、チームでする仕事をしていないせいもあってか、静かな環境の中で少し寂しくも感じてはいます。  
一義的には研究機関であるため、裁量労働制でみんな違う時間に出社するし、みんな違うテーマで仕事してるんですよね。  
その辺早く慣れたいですし、みなさんとも仲良くなっておきたいです。

最後に。1日でも早く、IIJのみなさんの利益につながる成果を出して、Haskell（と、私😤！）のすごさを社内外に知らしめたいです。  
実現できるよう日々精進して参りますので、今後ともよろしくお願いいたします！  
hask(\_ \_)eller

# それと

29歳になりました。  
同じ誕生日の著名人（？）としては、[ポムポムプリン](https://www.sanrio.co.jp/character/pompompurin/)先輩、[キュアカスタードこと有栖川ひまり](http://www.toei-anim.co.jp/tv/precure_alamode/character/chara02.php)ちゃんなどがいます。きっとひまりちゃんの誕生日も同じなのはプリン繋がりゆえのプリン先輩へのリスペクトでしょう🍮。  
[干し芋🍠のリストはこちらに](https://www.amazon.co.jp/gp/registry/wishlist/IVG2EM6PAME/ref=nav_wishlist_lists_1)ございますので、何かしら送っていただけると励みになります！
