require 'benchmark'

puts RUBY_VERSION
puts RUBY_PLATFORM

Benchmark.benchmark('その1! なんどもよばれる文字列リテラル') do|bm|
  bm.item ''
end

Benchmark.benchmark('その2! それ以外のオブジェクトもね！') do|bm|
  bm.item ''
end

Benchmark.benchmark('その3! キーワード引数とHashならどうかな？') do|bm|
  bm.item ''
end

Benchmark.benchmark('その4! defineする？それともe・va・l？') do|bm|
  bm.item ''
end

Benchmark.benchmark('その5! coerceする？それともto_f？') do|bm|
  bm.item ''
end

Benchmark.benchmark('もっと細かい編! concat vs +=') do|bm|
  bm.item ''
end
