---
title: 細かすぎて伝わらないRuby最適化Tips
author: 山本悠滋
date: 2015-08-06 表参道.rb #3

---

# こんにちは！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 26歳♂
- [Eight](https://8card.net/)のサーバーサイド担当です。
- 最近、[Haskellポエム](/posts/2015/1-predictable-programming.html)に目覚めました。

# こんにちは！

こういうの↓とか、

![](/imgs/dokidoki-fairies-01.png)

# こんにちは！

こういうの↓が大好きなおおきなおともだちです！

![](/imgs/paff-01.jpg)

# きょうのおはなし！

- **ふっつー**のプログラムを書いている限りはまず問題にならないけど、
- Rubyならできる、**みみっちい**最適化についておはなしするよ！
- ベンチマークに使ったスクリプトはこちらで！
    - [2015-08-06-compare-trivial-codes.rb](https://github.com/igrep/igreque.info/blob/master/prgs/2015-08-06-compare-trivial-codes.rb)

# きほん！

- オブジェクトづくりをへらそう！
- でも神経質になってもあんまりいいことはないよ！
    - Rubyのバージョンによって変わることもあるかもよ！

# その1! なんどもよばれる文字列リテラル

- Rubyさんは、文字列リテラルを評価するたびにあたらしいオブジェクトを作るよ！

# 文字列も必ず足されちゃう！

なのでこんな風に長い文字列リテラルを書きたいときは...

```ruby
"改行\n" +
  "しよう\n" +
  "そうしよう\n"
```

# 文字列も必ず足されちゃう！

よりも

```ruby
"改行\n" \
  "しよう\n" \
  "そうしよう\n"
```

- の方が速い！

# その2! それ以外のオブジェクトもね！

- Hashリテラルも、配列リテラルも！
- 期間を作るメソッドなども！

    ```ruby
    def hage
      4.days
    end
    ```

# その2! それ以外のオブジェクトもね！

そして散らばる定数

```ruby
class Hoge
  AAA = 'aaa'.freeze
  ONE_DAY = 1.day
  NANTOKA_TABLE = { ... }
  ...
end
```

# その3! キーワード引数とHashならどうかな？

# その4! defineする？それともe・va・l？

これ↓

```ruby
def hoge a
  puts a
end
```

# その4! defineする？それともe・va・l？

と、これ↓

```ruby
define_method :hoge do|a|
  puts a
end
```

- は、同じ？
- 違います。

# ブロックの外のローカル変数にアクセスできる

```ruby
a = 1
def foo
  a # エラー！
end

define_method :foo do
  a # エラーにならない！
end
```

# ブロックの外のローカル変数にアクセスできる

待てよ... できることが多いということは、  
その分オーバーヘッドがあるんじゃね...?

- やってみた。

# なので

メソッドを動的に定義したいとき、  
外のローカル変数にアクセスしなくてもよい時は  

```ruby
eval "
  def hoge
    #{なんか動的に変わる部分}
  end
"
```

のように、evalを使った方が速い！

# その5! coerceする？それともto_f？

# 結論！

- オブジェクトづくりをへらそう！
- 他にもRubyじゃみみっちくチューニングする余地がある！
- よっぽど速度にうえたときだけやろう！
- もっと細かいはなしがあったらおしえてほしいな！
