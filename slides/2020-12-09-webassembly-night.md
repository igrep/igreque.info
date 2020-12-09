---
title: Wasmコンパイラー作りの楽しみ
author: YAMAMOTO Yuji (山本悠滋)
date:  2020-12-09 WebAssembly night #10

---

# はじめまして！ 👋😄

- [山本悠滋](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell歴 ≒ プリキュアおじさん歴 ≒ 約8年。
- 趣味Haskeller兼仕事PureScripter @ [IIJ-II](https://www.iij-ii.co.jp/) 😁
    - 今日はHaskellなどの話はしません！
- igrep.elというEmacsプラグインがありますが無関係です！

# 🙇宣伝

- 🎊[IIJ Technical WEEKの3日目](https://iij.connpass.com/event/196667/)でもWasmの話をします！
    - 今日の話よりももっと全般的な、Wasmあまり詳しくない人向けの話です

# 📝今日話すこと

- [低レイヤを知りたい人のためのCコンパイラ作成入門](https://www.sigbus.info/compilerbook)にインスパイアされて、Wasmのコンパイラーを作っています
- Cはいろいろ闇が詰まってるけど、Wasmならきれい！
    - それでいて仕様も決まっていてアセンブリーに近いので、いいとこ取り！
- みんなもWasmコンパイラーを作って低レイヤーを学ぼう！

# ⚙️今作っているもの

[低レイヤを知りたい人のためのCコンパイラ作成入門](https://www.sigbus.info/compilerbook)にインスパイアされて**Wasmから**Arm32へのコンパイラーを作っています

- ソースはこちら: [igrep/wasm2arm32](https://github.com/igrep/wasm2arm32)
- 平日1日20分くらいしか時間をとれてないこともあり、開発開始から半年以上経つも全然です...😰

# 🤔なぜ作っているか

- 🔭あちらこちらで観測された、Wasm処理系開発ブームに遅れて乗った
- 😍Wasm大好きなんで完全に理解したい！
- 😼ついでに低レイヤーもちょっと知りたい！

# 💪なぜArm32か

- 純粋に勉強のためなら、今どきArm32はちょっと古い
    - 仕様もArm64より複雑で作りにくいらしいし
- WasmtimeやWasmerはじめ、著名な汎用Wasm処理系を調べた限り、Arm32をサポートしたJITコンパイラーはない！
- 💡古いRasPiをそのまま使う人もいるだろうし、需要あるのでは！？
    - 🙏練習問題が嫌いなので、少しでも役立ちそうなものを作りたい
    - 🙉~~実はNode.jsで事足りるという話は内緒！~~

# 💪なぜArm32か（続き）

（参考）たまたま身の回りにArm32での入門資料が豊富にあった

- [Assembly Language Tutorial](https://www.newthinktank.com/2016/04/assembly-language-tutorial/)
- [Raspberry Pi Assembly Language Programming](https://link.springer.com/book/10.1007/978-1-4842-5287-1)

# 👍Wasmコンパイラー作りの何が良いか

- ✅Wasmは[参考にしたCコンパイラ作成入門](https://www.sigbus.info/compilerbook)が掲げる条件を、C以上にバッチリ満たしている！

# 👍[参考にしたCコンパイラ作成入門](https://www.sigbus.info/compilerbook)がCを選んだ理由（要約）

- ✅CPUの命令セットやプログラムの仕組みを同時に学べる！
    - 普通アセンブリーにコンパイルするので！
- ✅第三者のコードをダウンロードしてコンパイルできる！
    - [著者は自作のCコンパイラーでgitのコンパイルにも成功したらしい](https://twitter.com/rui314/status/1302620742882746368)

# 👍[参考にしたCコンパイラ作成入門](https://www.sigbus.info/compilerbook)がCを選んだ理由（要約）（続き）

- ✅言語仕様が小さい！
    - C++は、言語仕様があまりにも巨大で、気軽に自作コンパイラを作るのは不可能！
- ✅仕様が決まっている！
    - 自作言語と違ってサボることができない！

# 👍一方我らがWebAssembly

- ✅CPUの命令セットやプログラムの仕組みを同時に学べる！
    - コンパイラーにすればOK！
- ✅第三者のコードをダウンロードしてコンパイルできる！
    - CでもC以外でもWasmにコンパイルしてからならOK！

# 👍一方我らがWebAssembly

- ✅言語仕様が小さい！
    - （多分）Cより小さい！
- ✅仕様が決まっている！
    - Well defined! [testsuite](https://github.com/WebAssembly/testsuite/)さえある！

# 👍しかもWasmは！

- Cのような不浄な構文がない！
    - WATをサポートするとなると、ちょいちょい仕様が変わってたみたいですが...
- よりアセンブリーに近く、実装も簡単（なはず）
- WATまでちゃんとサポートすれば、構文解析もそれなりに学べる
    - ※今回はパーサーはバイナリーフォーマットも含めて全く書いてません！🙇
    - S式をちょっと改造した程度のものなので、Cのパーサーよりは簡単なはず！

# 開発してて大変なところ💦

[testsuite](https://github.com/WebAssembly/testsuite/)はあるものの、テストランナーは自分で書かないといけない！

- WASTという専用のフォーマット。
- [wast2json](https://webassembly.github.io/wabt/doc/wast2json.1.html)というツールでJSONにはできるものの、その先は処理系実装者の仕事
- 今回はRustでJSONを解釈してテストの実行そのものはアセンブリーで書いたので結構大変だった

# 開発してて大変なところ💦（続き）

😩意外と素直に行かない翻訳

- Wasmの命令にぴったり対応する命令がArm32にあるとは限らない！
    - [`i32.ctz`などは自前で実装しました...](https://github.com/igrep/wasm2arm32/blob/3547ac77dc78f3962b3fbc803b58154981ca160c/src/core.rs#L105-L156)
- 数値リテラルすら値によってはアセンブル時にエラーが出たり
    - 参考1: [アセンブリ言語 - アセンブリで　movするとエラーになる値がある事について。｜teratail](https://teratail.com/questions/102402)
    - 参考2: [arm - GCC: invalid literal constant: pool needs to be closer - Stack Overflow](https://stackoverflow.com/questions/36740646/gcc-invalid-literal-constant-pool-needs-to-be-closer)

# 今後

- 当然未実装の仕様はなるべく...
- なるべく新しい仕様もサポートできたらなぁ😥（淡い願望）
    - スレッドとか、multi valueとか、例外とか
- 現状はアセンブリーを吐いてgccに食わせることでオブジェクトコードを生成
    - JITにするつもりだったけどどうせJITはNode.jsがやっているのでこのままクロスコンパイラーということにしよう

# まとめ

- 🤗Wasmコンパイラー作り、低レイヤーの入門にぴったりすぎるのでは！？
    - Cよりきれいで、仕様が決まってて、お手軽！
- 📕[低レイヤを知りたい人のためのCコンパイラ作成入門](https://www.sigbus.info/compilerbook)はマジ名著。早く本になってくれ
- みんなもWasmコンパイラーを作って低レイヤーを学ぼう！
