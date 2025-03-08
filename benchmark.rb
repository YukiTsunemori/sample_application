# frozen_string_literal: true

require 'benchmark'
symbol = { foo: 'value' }
string = { 'foo' => 'value' }
integer = { 1 => 'value' }
Benchmark.bmbm do |x|
  x.report('Symbol') { symbol[:foo] }
  x.report('String') { string['foo'] }
  x.report('Integer') { integer[1] }
end
