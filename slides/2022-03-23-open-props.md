---
title: Open Props の紹介
author: YAMAMOTO Yuji (山本悠滋)
date:  2022-03-23 ラクスR&D Meetup - CSSフレームワーク

---

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約10年。
- 趣味Haskeller兼仕事TypeScripter @ [IIJ-II](https://www.iij-ii.co.jp/)
- igrep.elというEmacsプラグインがありますが無関係です！

# 📝今日話すこと

- [Open Props](https://open-props.style/)というCSSフレームワークは、わざわざCSSを書きたい**ドM**向けのフレームワークです
    - 俺はどうしても普通にCSSを書きたいんだ！でもある程度の規約としてフレームワークが欲しいんだ！という人向け
- ちなみに今仕事でやっているプロジェクトはOpen Propsと[CSS Modules](https://github.com/css-modules/css-modules)、SCSS、BEMなどを採用しています

# 🏋️自己紹介: どうしてもCSSを書きたい人

1. CSSフレームワークが世に溢れる前から自前でちまちまと小規模なCSSを書いて楽しんでいた
    - 例: [手製のブログ](https://the.igreque.info/)
    - そういう成功体験があるからかも
1. 就職して仕事でBootstrap製の管理サイトを触るも、イヤイヤやってた😩
1. 今もTailwindCSSを覚えるのに抵抗が😰
    - 事実上「CSSじゃなく見える別言語」なのが怖い

# 🌠そんな時に現れたOpen Props

提供するのはユーティリティークラス*ではなく*ユーティリティー**変数**！

[いろいろ使った例](https://codepen.io/igrep/pen/jOYqZPp):

```css
#example {
  color: var(--gray-2);
  font-family: var(--font-mono);
  width: var(--size-xs);
  border-radius: var(--radius-blob-2);
  font-size: var(--font-size-fluid-3);
  padding: var(--size-fluid-5);
  background-image: var(--gradient-3);
}
```

# 💁‍♂Open Propsがもたらすもの

- 😍一貫して定義された、よく使いそうなCSS変数をたくさん！
    - 📱media queryでよく使うルールも！
    - 💃アニメーションも！
- 📓あくまでサイズや色などの選択肢を狭める（= 規約を与える）だけ
    - 💪もちろん変数の命名体系だけ借りて一部を自力で定義してもいい
- 😌よくあるユーティリティークラスをたくさん提供するフレームワークよりは覚えやすそう

# 💰さらに！

- [normalizeを使えば、既存のタグをいい感じにしてくれる！](https://codepen.io/argyleink/pen/KKvRORE)
    - クラスの定義をサボりたいときも便利！
    - ダークテーマ・ライトテーマの切り替えも標準でサポート！
- [postcss-jit-props](https://github.com/GoogleChromeLabs/postcss-jit-props)を使えば、実際に使っているCSS変数に絞れる

# まとめ

- 🤗Open Propsを使えば、CSSのプロが作ったデザインシステムの恩恵にあずかりながら、普通にCSSを書ける！
    - 🙌略語にまみれたクラス群におびえる必要なし！
