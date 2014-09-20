% Crispy in a Nutshell
% 山本悠滋
% 2014-09-21 Ruby Hiroba

# はじめまして！

- [山本悠滋](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) 25歳♂
- [Sansan](http://www.sansan.com/)という会社でRailsを触ってます。
- [Yokohama.rb](http://yokohamarb.doorkeeper.jp/) の RubyKaja 2014に選ばれました。ありがとう！
- [Haskellの勉強会](http://connpass.com/series/754/)をツキイチでやってます！

# 今日話すこと

- [crispyというgem](http://rubygems.org/gems/crispy)を作ったので紹介させてください！
- And Star [github.com/igrep/crispy](http://github.com/igrep/crispy)

# What's Crispy

- New test double library for Ruby.
- 競合: rspec-mocks, rr, etc.
- **あらゆる**オブジェクトをspyできます。

# Crispy is:

- **あらゆる**オブジェクトに対するspyです。

# Let's Compare!

open [crispy/pull/12](https://github.com/igrep/crispy/pull/12/files)

# おなじみのメソッドが使えるよ！

- `received_messages`というメソッドに、呼び出したメソッドと引数を表すオブジェクトのArrayが！
- `expect(x).to receive(:m).with(...)` の `with(...)`に相当する機能。

# おなじみのメソッドが使えるよ！

- だから！
- おなじみのEnumerableのメソッドが使えるよ！
    - 学習コスト爆安!!!
- **もっと自由に**message expectationができるよ！

# おなじみのEnumerableのメソッドが使えるよ！

- 続きは[README](https://github.com/igrep/crispy#get-more-detailed-log)で！

# まとめ

- [crispy](http://rubygems.org/gems/crispy)は多分史上初のあらゆるObjectに使えるTest Spy
    - どこで`expect(...).to receive()`を呼ぶか悩む時代は終わりました！
- みんな大好きEnumerableのメソッドを使って、柔軟かつ簡単にspyが受け取ったメッセージを調べられます。
- Star [github.com/igrep/crispy](http://github.com/igrep/crispy)
