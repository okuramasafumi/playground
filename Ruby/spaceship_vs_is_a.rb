# This comparison comes from https://github.com/rails/rails/pull/39009#discussion_r412499937
# I wondered using spaceship is actually faster than is_a?(Numeric).
# Here's the ressult.

require 'benchmark'

Benchmark.bmbm do |x|
  times = 100000000
  x.report(:bmbm_is_a_numeric) { times.times { 1.is_a?(Numeric) } }
  x.report(:bmbm_spaceship_numeric) { times.times { 1 <=> 0 } }
  x.report(:bmbm_is_a_nil) { times.times { nil.is_a?(Numeric) } }
  x.report(:bmbm_spaceship_nil) { times.times { nil <=> 0 } }
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
#
require 'benchmark/ips'

Benchmark.ips do |x|
  x.time = 10
  x.report(:ips_is_a_numeric) { 1.is_a?(Numeric) }
  x.report(:ips_spaceship_numeric) { 1 <=> 0 }
  x.report(:ips_is_a_nil) { nil.is_a?(Numeric) }
  x.report(:ips_spaceship_nil) { nil <=> 0 }
end

# Warming up --------------------------------------
#     ips_is_a_numeric     1.978M i/100ms
# ips_spaceship_numeric
#                          2.126M i/100ms
#         ips_is_a_nil     1.998M i/100ms
#    ips_spaceship_nil     1.622M i/100ms
# Calculating -------------------------------------
#     ips_is_a_numeric     19.624M (± 3.3%) i/s -    197.824M in  10.094179s
# ips_spaceship_numeric
#                          20.509M (± 9.3%) i/s -    204.126M in  10.087055s
#         ips_is_a_nil     19.783M (± 4.0%) i/s -    197.802M in  10.017880s
#    ips_spaceship_nil     16.138M (± 1.0%) i/s -    162.249M in  10.055148s
