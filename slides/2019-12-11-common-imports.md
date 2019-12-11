---
title: importを共通化したい話
author: Yuji Yamamoto (山本悠滋)
date: 2019-12-11 GHC勉強会

---

# あらまし

- 「moduleのqualified nameをそのままexportする仕様変更」として、二つの対立するproposalが議論されている
    - まだ仕様も固まっていないので、リリースされるのは当分先
- 実現すると`Prelude`作りが捗る
- 「moduleのグループ」を設計しやすくなり、大規模なアプリケーションの開発が楽になりそう

# 「moduleのqualified nameをそのままexportする」とは？

[Local modules](https://github.com/goldfirere/ghc-proposals/blob/local-modules/proposals/0000-local-modules.rst#3further-examples)の例を超簡略化:

```haskell
module A ( qualified module M1 ) where


import qualified Import1 as M1
```

- exportする側で👆のように書いて、

# 「moduleのqualified nameをそのままexportする」とは？

[Local modules](https://github.com/goldfirere/ghc-proposals/blob/local-modules/proposals/0000-local-modules.rst#3further-examples)の例を超簡略化:

```haskell
module B where
import A ( module M1 )
-- あるいは、👇と書くとM1がexportする識別子が M1. なしで使える
import A ( import module M1 )
```

- `import`する側で👆のように書くと、`M1.`というprefix付きで`Import1`の識別子が使える

# 実現するとできそうなこと(1)

- 自作`Prelude`で「どのモジュールをどう`qualified`して`import`するか」を明示できるようになる
    - `RIO`ではstrictな`ByteString`とlazyな`ByteString`を同じモジュールからexportするために[`type LByteString = ByteString`](http://hackage.haskell.org/package/rio-0.1.12.0/docs/RIO-Prelude-Types.html#t:LByteString)なるものを定義しているが、そんな必要もなくなる！
    - ➡️`Prelude`作りがもっとお手軽に！

# 実現するとできそうなこと(1)

`Prelude`作りがお手軽になると...

- 「moduleのグループ」毎の依存関係を明示しやすくなり、大規模なソフトウェアの開発が楽になりそう
    - 「このディレクトリー以下のモジュールは同じディレクトリーの`Prelude`以外`import`しちゃいけない」みたいなルールを設定すれば、モジュール間の依存の可否を明示しやすくなる
    - cf. [chromiumプロジェクトにおけるDEPSファイル](https://nhiroki.jp/2017/12/01/chromium-sourcecode#%E5%90%84%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E5%86%85%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%A7%8B%E6%88%90)

# 議論の流れ

1. deepfire: [Structured module exports/imports #205](https://github.com/ghc-proposals/ghc-proposals/pull/205)
1. ⬇️「more compositional」にしよう
1. goldfirere: [Local modules #283](https://github.com/ghc-proposals/ghc-proposals/pull/283)
1. ⬇️「実はそっくりな拡張を考えてたんだ」
1. michaelpj: [WIP: First class modules #295](https://github.com/ghc-proposals/ghc-proposals/pull/295)
1. Local modules v.s. First class modules ⬅️ｲﾏｺｺ!

# Local modules v.s. First class modules

どちらも「`module`の`qualified` nameをそのままexportする」を一般化して、

「**`module`の中で入れ子の`module`を定義**」できるようにしている:

- どちらのproposalでも「Local Module」と呼ばれているもの

# Local modules v.s. First class modules

[First class modules](https://github.com/michaelpj/ghc-proposals/blob/imp/first-class-modules/proposals/0000-first-class-modules.rst#131exporting-small-utility-modules)の例から:

```haskell
module A (f, module Unsafe) where

f = Unsafe.g …

module Unsafe where
  g = …
```

# Local modules v.s. First class modules

構文が違う（[First class modules](https://github.com/michaelpj/ghc-proposals/blob/imp/first-class-modules/proposals/0000-first-class-modules.rst#15alternatives)側の主張から）:

> - Export specifiers
>     - The export specifiers in [ghc283] are quite complex, and there are questions about how they should behave for nested modules etc. The export specifiers in this proposal are extremely simple: they just allow exporting a module name. All additional structure must be added by structuring the exported module.

# Local modules v.s. First class modules

First class modules:

- `ExportModuleNames`: exportするときの構文の意味を変えよう
    - module `M` changes to exports the name M as a module binding.
        - 非互換な修正！
    - module `M(a, b, .. c)` exports M and some of its names.
    - module `M(..)` exports M and all of its names.
    - ~~山本悠滋注: `qualified`したときの説明がないよ！exampleには出てるのに！~~

# Local modules v.s. First class modules

Local modulesが変えようとしている構文:

11. Local modules may be exported with this export item:

```haskell
export_item ::= ... | [ 'qualified' ] 'module' conid [ export_spec ]
```

- ~~🤔「First class modules」側の提案と大して変わらない？~~

# Local modules v.s. First class modules

ほかにもLocal modulesは、`import`や`module`に関して新しい構文を定義している

10. Local modules may be imported with this import item:

```haskell
import_item ::= ... | [ 'import' ] 'module' conid [ import_spec ]
```

- 👆これは入れ子になっているmoduleを`import`するときの構文
    - 例: `import A ( import module M1 )`
- 確かにちょっと複雑

# 実現するとできそうなこと(2)

どちらの提案であれ、moduleの作者がユーザーに、`qualified import`するのを強制できる

- [Local modules](https://github.com/goldfirere/ghc-proposals/blob/local-modules/proposals/0000-local-modules.rst#1motivation)の「5」から:

```haskell
module Data.Set ( Set, qualified module Set ) where

  import module Set ( Set )
  module Set ( Set, fromList ) where
    data Set = ...
    fromList = ...
```

# 所感

- 互いのexampleをもう一方に翻訳して欲しい...
- Local modulesの方が確かに複雑に見えるが、First class modules側には構文をどう拡張するかが定義されてない部分が多いので、イマイチわかりづらい
- Local modulesのBNF、[Haskell 2010 Report](https://www.haskell.org/onlinereport/haskell2010/haskellch5.html#x11-1010005.3)に載っているのとルールの名前が違うような...
- 議論を細かく追うことまではできなかったのですが
    - [michaelpjのこの発言](https://github.com/ghc-proposals/ghc-proposals/pull/283#issuecomment-549783771)と
    - [goldfirereのこの発言](https://github.com/ghc-proposals/ghc-proposals/pull/295#issuecomment-556037564)がポイント？
