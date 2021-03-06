---
title: Predefを使ったSQLのトレース
author: 山本悠滋
date: 2015-06-04 表参道.rb #1

---

# こんにちは！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 26歳♂
- [Eight](https://8card.net/)のサーバーサイド担当です。
- 最近はCoffeeScriptでクライアントをよく触ります。
- [Haskellの勉強会](http://haskellmokumoku.connpass.com/)を毎月やっとります。

# 小さな小さなgemを作りました

<div class="takahashiLike incremental">
[predef](https://github.com/igrep/predef)と言います
</div>

# 小さな小さなgemを作りました

<div class="takahashiLike">
使ったことある人ー ( ＾ω＾)ノ
</div>

# 小さな小さなgemを作りました

<div class="takahashiLike">
~~リリースまだですけどwww~~

=> しました！ [predef](https://rubygems.org/gems/predef)
</div>

# なにするgem?

- 「Module#prependしてdefするgem」略して「predef」
- ただのModule#prependのショートカット

# なにするgem?

例えば...

```ruby
class SomeExternalClass
  def method_you_know(*args)
    ...
  end
end
```

- ↑みたいな（外部のライブラリなど、直接触りづらい）クラスがあったとして

# なにするgem?

例えば...

```ruby
Predef.predef SomeExternalClass, :method_you_know do|*args|
  p args
  super(*args)
end
```

- ↑みたいにすると
    - 対象のメソッドの前後に好きな処理を加えられちゃう♪
    - この場合、引数を出力する処理を加えちゃう♪

# なにするgem?

やってることは実質これ↓と同じ

```ruby
module Wrapper
  def method_you_know *args
    p args
    super(*args)
  end
end

class SomeExternalClass
  prepend Wrapper
end
```

- 詳しくはprependでググってください。

# なにするgem?

- 余計なmoduleを定義しなくて済む
- ただそれだけなんで別に無理に使う必要もない

# 事例

アプリ上で発行されうる**全ての**SQLと、その場所を把握したい

- ActiveRecord任せのためどこでどんなクエリを発行するか分かりにくくなりがち
- ただし、SELECT・DELETE・UPDATEのみ。
    - INSERTやその他DDLなどはテストでだけ実行されるケースが多い。
    - あと、要件上あまり関心がなかった。

# 事例

アプリ上で発行されうる**全ての**SQLと、その場所を把握したい

- `Mysql2::Client#query`メソッドをラップした上で、全テストを実行
    - 最終的にActiveRecordが実行するはずなので、漏れがない
    - ラップした`query`メソッドで受け取った引数と、バックトレースをログに出す
- カバレッジもとり、カバーできてない分のみコードを読む

# 事例

アプリ上で発行されうる**全ての**SQLと、その場所を把握したい

- こんな感じ...

    ```ruby
    Predef.predef Mysql2::Client, :query do|sql|
      if sql =~ /SELECT|UPDATE|DELETE/
        puts sql
        pp caller
      end
      super(sql) # 引数を忘れずに
    end
    ```

# 事例

アプリ上で発行されうる**全ての**SQLと、その場所を把握したい

- で、こんな感じの出力が！

    ```sql
    SELECT * from your_apps_table WHERE ...
    ["/path/to/your_app/app/models/foo.rb:355:in `some_method_in_model'",
      ...]
    ```

# Tips

- Refinementsも用意してます
- 使い方

    ```ruby
    using Predef::Refinements

    Mysql2::Client.predef :query do|sql|
      ...
    end
    ```

# まとめ（みなさん向け）

```bash
$ gem install predef
```

# まとめ（みなさん向け）

```ruby
require 'predef'

using Predef::Refinements

Mysql2::Client.predef :query do|sql|
  puts sql if sql =~ /.../
  super(sql)
end
```

# まとめ（私向け）

<div class="incremental">
~~さっさと `bundle exec rake release` しなさい。~~  
こちらも終了: [predef](https://rubygems.org/gems/predef)
</div>
