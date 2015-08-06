require 'optparse'
require 'benchmark'

N = ARGV.getopts('n:1000_0000')['n'].to_i
TARGETS = ARGV

def run_bm label, &block
  if TARGETS.empty? || (TARGETS.any? {|target| label.include? target })
    puts '                                     user     system      total        real'
    Benchmark.benchmark(label, &block)
  end
end

puts RUBY_VERSION
puts RUBY_PLATFORM

run_bm("その1! なんどもよばれる文字列リテラル\n") do|bm|
  bm.item '何度も呼ばれるブロックの外で初期化' do
    a = '0123456789'
    N.times do
      a
    end
  end

  bm.item '何度も呼ばれるブロックの中で初期化' do
    N.times do
      '0123456789'
    end
  end

  bm.item '何度も呼ばれるブロックの中でfreezeして初期化' do
    N.times do
      '0123456789'.freeze
    end
  end

  bm.item '長い文字列リテラル: +で連結' do
    N.times do
      "改行\n" +
        "しよう\n" +
        "そうしよう\n"
    end
  end
  bm.item '長い文字列リテラル: \\で連結' do
    N.times do
      "改行\n" \
        "しよう\n" \
        "そうしよう\n"
    end
  end

end

run_bm("その2! それ以外のオブジェクトもね！\n") do|bm|
  bm.item '何度も呼ばれるブロックの外でHashを初期化' do
    a = {}
    N.times do
      a
    end
  end
  bm.item '何度も呼ばれるブロックの中でHashを初期化' do
    N.times do
      {}
    end
  end

  bm.item '何度も呼ばれるブロックの外でArrayを初期化' do
    a = []
    N.times do
      a
    end
  end
  bm.item '何度も呼ばれるブロックの中でArrayを初期化' do
    N.times do
      []
    end
  end

  bm.item '何度も呼ばれるブロックの外でObjectを初期化' do
    a = Object.new
    N.times do
      a
    end
  end
  bm.item '何度も呼ばれるブロックの中でObjectを初期化' do
    N.times do
      Object.new
    end
  end

end

run_bm("その3! キーワード引数とHashならどうかな？\n") do|bm|
  bm.item 'キーワード引数で引数定義' do
    def hoge3(b:, c:)
    end
    N.times do
      hoge3(b: 1, c: 2)
    end
  end

  bm.item 'Hashで引数定義' do
    def foo3(_args)
    end
    N.times do
      foo3(b: 1, c: 2)
    end
  end
end

run_bm("その4! defineする？それともe・va・l？\n") do|bm|
  bm.item 'define_methodで定義したメソッドを使う' do
    a = 1
    define_method :hoge4 do
      a
    end
    N.times do
      hoge4
    end
  end

  bm.item 'eval defで定義したメソッドを使う' do
    a = 1
    binding.eval %Q{
      def foo4
        #{a}
      end
    }
    N.times do
      foo4
    end
  end
end

run_bm("その5! coerceする？それともto_f？\n") do|bm|
  a = 1
  b = 1
  bm.item 'Floatへの変換をcoerceに任せる1' do
    N.times do
      a + b.to_f
    end
  end
  bm.item 'Floatへの変換をcoerceに任せる2' do
    N.times do
      a.to_f + b
    end
  end
  bm.item 'Floatへの変換をto_fで行う' do
    N.times do
      a.to_f + b.to_f
    end
  end
end
