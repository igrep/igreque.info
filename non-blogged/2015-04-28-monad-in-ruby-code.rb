# Ruby語でもおk!

module Monad
  def bind &block
    raise NotImplementedError
  end
  def return x
    raise NotImplementedError
  end
end

# mがMonadをincludeしたクラスのインスタンス、
# hoge1, hoge2がそのインスタンスを返す関数だとして、

m.bind do|a|
  hoge1(a).bind do|b|
    hoge2(b)
  end
end

と、

m.bind do|a|
  hoge1(a)
end.bind do|b|
  hoge2(b)
end

が、同じ意味になること！

=begin
「bind」を
「レシーバーがnilだったら付属のブロックを実行しないで、
レシーバーがnil以外だったら付属のブロックを実行する」、
という処理だとしてみましょう。

nilとnil以外のオブジェクトなんで、
Objectに実装しちゃいましょう。
=end

class Object
  include Monad
  def bind &block
    block.call unless self.nil?
  end
end

# 使い方

x1.bind do|y1|
  hoge(y1)
end.bind do|x2|
  # ...
end

=begin
「bind」を
ファイルを開いて、プログラムの最後に必ず閉じる、という処理だとしてみましょう。
=end

class Open
  include Monad
  def initialize file_name
    @file_name
  end
  def bind &block
    file = File.open @filename
    at_exit { file.close }
    block.call file
  end
end

# 使い方

Open.new(path1).bind do|file1|
  hoge file1
end
Open.new(path2).bind do|file2|
  foo file2
end

# bindの戻り値を使っていないことからしてちょっと不規則ですが、これもアリです。
# returnが関係しているのですが、詳しい事情は省略します...


# ちなみにこれは、File.openで以下のように書いたのとよく似たことをしています。

File.open(path1) do|file1|
  hoge file1
  File.open(path2) do|file2|
    hoge file2
  end
end

=begin
「bind」を「何かする」という処理だとしてみましょう。

Rubyで「何かする」を表すオブジェクトといえばProcですね。
=end

class Proc
  include Monad
  def bind &block
    result = self.call
    block.call result
  end
end

# 使い方

-> { puts "hello" }.bind do
  puts "world!"
end
