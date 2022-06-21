---
title: 退職届のテンプレートをHTMLで書きました
author: Yuji Yamamoto
date: April 17, 2018
...
---

[先日報告した](01-gmo-iij.html)とおりGMOフィナンシャルホールディングス株式会社を退職した私ですが、退職届を書く際、HTMLで書くというちょっとした工夫（？）をしてみました。  
探せばテンプレートもありますし、WordやExcelで書いてもよかったのですが、長年のVimmerである私にとっては、Vimと過ごす時間は少しでも長くしたいですよね。  
各種ブラウザーベンダー様が[CSS writing-mode property](https://caniuse.com/#feat=css-writing-mode)をサポートしてくれたおかげで、今時はCSSで縦書きにするのも簡単になりましたし、HTMLで書けない理由がありません！

と、言うわけでHTMLで書いたので、せっかくなんでテンプレートを共有致します！

[resignation.html](/works/resignation.html)

中身はごく単純なHTMLファイルです。  
CSSもHTMLの中に直接書いているので、

```
wget http://the.igreque.info/works/resignation.html
```

と、コマンドで取得することもできるでしょう。

あとは適当に必要な箇所を書き換え、お手元のブラウザーで開いて印刷するだけです！  
退職の際は是非ご利用ください！  
<small>（実は前々職を辞める際にもHTMLで書いていたのですが、共有し忘れていました）</small>
