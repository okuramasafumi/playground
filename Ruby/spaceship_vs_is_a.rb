require 'benchmark'

Benchmark.bmbm do |x|
  times = 100000000
  x.report(:is_a_numeric) { times.times { 1.is_a?(Numeric) } }
  x.report(:spaceship_numeric) { times.times { 1 <=> 0 } }
  x.report(:is_a_nil) { times.times { nil.is_a?(Numeric) } }
  x.report(:spaceship_nil) { times.times { nil <=> 0 } }
end

# Rehearsal -----------------------------------------------------
# is_a_numeric        4.021770   0.035042   4.056812 (  4.117585)
# spaceship_numeric   3.858403   0.032344   3.890747 (  3.946810)
# is_a_nil            4.185507   0.036329   4.221836 (  4.283727)
# spaceship_nil       5.333476   0.049582   5.383058 (  5.478110)
# ------------------------------------------- total: 17.552453sec

#                         user     system      total        real
# is_a_numeric        4.018294   0.036411   4.054705 (  4.116184)
# spaceship_numeric   3.848957   0.034442   3.883399 (  3.937972)
# is_a_nil            4.176719   0.035917   4.212636 (  4.270753)
# spaceship_nil       5.219250   0.044142   5.263392 (  5.341316)
