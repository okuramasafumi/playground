require 'benchmark'

Benchmark.bmbm do |x|
  times = 100000000
  x.report(:is_a) { times.times { 1.is_a?(Numeric) } }
  x.report(:spaceship) { times.times { 1 <=> 0 } }
end

# Rehearsal ---------------------------------------------
# is_a        4.069698   0.037524   4.107222 (  4.181472)
# spaceship   3.886661   0.036528   3.923189 (  3.988225)
# ------------------------------------ total: 8.030411sec

#                 user     system      total        real
# is_a        4.082623   0.034566   4.117189 (  4.174784)
# spaceship   3.901275   0.033486   3.934761 (  3.987853)
