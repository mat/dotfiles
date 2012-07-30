#!/usr/bin/env ruby

#
# R like stats
#
# $ cat nums
#  2.1
#  1.337
# $ cat nums | bin/rlikestats.rb
#  #Values  :             2
#  Min      :        1.3370
#  1st Qu.  :        1.3370
#  Median   :        2.1000
#  Mean     :        1.7185
#  3rd Qu.  :        2.1000
#  90th Pct.:        2.1000
#  95th Pct.:        2.1000
#  99th Pct.:        2.1000
#  Max      :        2.1000
#  Stddev   :        0.5395

class Rlikestats

  def initialize
    @values = []
    @count = 0
    @mean  = 0.0
    @lines = 0
    @m2 = 0.0
  end

  def run
    while line = $stdin.gets
      @lines += 1
      unless line =~ /^\d/
        $stderr.puts "Skipping line #{lines}: #{line}"
        next
      end
      val = line.to_f
      @count += 1

      delta = val - @mean
      @mean = @mean + delta / @count
      @m2 += delta * (val - @mean)

      @values << val
    end
    variance = @m2 / (@count - 1)
    @stddev = Math.sqrt(variance)

    @values.sort!
    print_result
  end

  private
  def print_result
    puts "#Values  :  %12d"   % @values.size
    puts "Min      :  %12.4f" % @values.first
    puts "1st Qu.  :  %12.4f" % percentile(0.25)
    puts "Median   :  %12.4f" % percentile(0.50)
    puts "Mean     :  %12.4f" % @mean
    puts "3rd Qu.  :  %12.4f" % percentile(0.75)
    puts "90th Pct.:  %12.4f" % percentile(0.90)
    puts "95th Pct.:  %12.4f" % percentile(0.95)
    puts "99th Pct.:  %12.4f" % percentile(0.99)
    puts "Max      :  %12.4f" % @values.last
    puts "Stddev   :  %12.4f" % @stddev
  end

  def percentile(pct)
    @values[(@count * pct).floor]
  end
end

Rlikestats.new.run
