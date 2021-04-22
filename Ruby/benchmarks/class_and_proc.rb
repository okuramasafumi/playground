# I wanted to measure the difference of normal class initialization and lambda literal.
# The result is kind of interesting:
# Warming up --------------------------------------
#         C.new.call     11.037M i/s -     11.087M times in 1.004484s (90.60ns/i)
#          ->{}.call      4.255M i/s -      4.412M times in 1.036914s (235.02ns/i)
#Calculating -------------------------------------
#         C.new.call     12.742M i/s -     33.112M times in 2.598582s (78.48ns/i)
#          ->{}.call      4.346M i/s -     12.765M times in 2.937056s (230.09ns/i)
#
#Comparison:
#         C.new.call :  12742305.6 i/s
#          ->{}.call :   4346138.4 i/s - 2.93x  slower

require 'benchmark_driver'

Benchmark.driver do |x|
  x.prelude <<~RUBY
    class C
      def call
      end
    end
  RUBY

  x.report %{ C.new.call }
  x.report %{ ->{}.call }
end
