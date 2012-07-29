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

  attr_accessor :values, :count, :mean, :lines

  def initialize
    self.values = []
    self.count = 0
    self.mean  = 0.0
    self.lines = 0
    self.m2 = 0.0
  end

  def run
    while line = $stdin.gets
      self.lines += 1
      unless line =~ /^\d/
        $stderr.puts "Skipping line #{lines}: #{line}"
        next
      end
      val = line.to_f
      self.count += 1

      delta = val - mean
      self.mean = mean + delta / count
      self.m2 = m2 + delta * (val - mean)

      values << val
    end
    variance = m2 / (count - 1)
    self.stddev = Math.sqrt(variance)

    values.sort!
    print_result
  end

  def percentile(pct)
    values[(count * pct).floor]
  end

  def print_result
    puts "#Values  :  %12d"   % values.size
    puts "Min      :  %12.4f" % values.first
    puts "1st Qu.  :  %12.4f" % percentile(0.25)
    puts "Median   :  %12.4f" % percentile(0.50)
    puts "Mean     :  %12.4f" % mean
    puts "3rd Qu.  :  %12.4f" % percentile(0.75)
    puts "90th Pct.:  %12.4f" % percentile(0.90)
    puts "95th Pct.:  %12.4f" % percentile(0.95)
    puts "99th Pct.:  %12.4f" % percentile(0.99)
    puts "Max      :  %12.4f" % values.last
    puts "Stddev   :  %12.4f" % stddev
  end

  private
  attr_accessor :m2, :stddev
end

Rlikestats.new.run
