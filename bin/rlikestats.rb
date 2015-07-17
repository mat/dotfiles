#!/usr/bin/env ruby

#
# R like stats
#
# $ cat nums
#  2.1
#  1.337
# $ cat nums | bin/rlikestats.rb [-b 10]
#
# Summary:
# #Values  :             2
# Total    :        3.4370
# Min      :        1.3370
# Max      :        2.1000
# Mean     :        1.7185
# Stddev   :        0.5395
#
# Histogram:
#   1.337 [1]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
#   1.413 [0]	|
#   1.490 [0]	|
#   1.566 [0]	|
#   1.642 [0]	|
#   1.719 [0]	|
#   1.795 [0]	|
#   1.871 [0]	|
#   1.947 [0]	|
#   2.024 [0]	|
#   2.100 [1]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
#
# Distribution:
#    10% in 1.3370
#    25% in 1.3370
#    50% in 2.1000
#    75% in 2.1000
#    90% in 2.1000
#    95% in 2.1000
#    99% in 2.1000
#  99.9% in 2.1000
#  99.99% in 2.1000

class Rlikestats

  def initialize
    @values = []
    @count = 0
    @sum   = 0.0
    @mean  = 0.0
    @lines = 0
    @m2 = 0.0
  end

  def run
    while line = $stdin.gets
      @lines += 1
      unless line =~ /^\d/
        $stderr.puts "Skipping line #{@lines}: #{line}"
        next
      end
      val = line.to_f
      @count += 1
      @sum += val

      delta = val - @mean
      @mean = @mean + delta / @count
      @m2 += delta * (val - @mean)

      @values << val
    end
    variance = @m2 / (@count - 1)
    @stddev = Math.sqrt(variance)

    @values.sort!

    if @values.size > 0
      print_summary
      print_histogram
      print_distribution
    else
      $stderr.puts "Empty input"
    end
  end

  private
  def print_summary
    puts("\nSummary:\n")
    puts "#Values  :  %12d"   % @values.size
    puts "Total    :  %12.4f" % @sum
    puts "Min      :  %12.4f" % @values.first
    puts "Max      :  %12.4f" % @values.last
    puts "Mean     :  %12.4f" % @mean
    puts "Stddev   :  %12.4f" % @stddev
  end

  def print_histogram
    buckets, counts = calculate_histogram

    puts("\nHistogram:\n")
    max = counts.max
    buckets.each_index do |i|
      bar_len = counts[i] * 40 / max
      bar = "∎" * bar_len
      printf("  %4.3f [%d]\t|%s \n", buckets[i], counts[i], bar)
    end
  end

  PERCENTILES = [10, 25, 50, 75, 90, 95, 99, 99.9, 99.99]
  def print_distribution
    puts("\nDistribution:\n")
    PERCENTILES.each do |p|
      printf(" %4g%% in %4.4f\n", p, percentile(p/100.0))
    end
  end

  def calculate_histogram
    if bucket_arg = ARGV.index("-b")
      bucket_count = Integer(ARGV[bucket_arg + 1])
    else
      bucket_count = 10
    end
    width = (@values.last - @values.first) / bucket_count.to_f
    counts = Array.new(bucket_count+1) { 0 }
    buckets = Array.new(bucket_count+1) { 0.0 }

    0.upto(bucket_count) do |i|
      buckets[i] = @values.first + i.to_f*width
    end

    bi = 0
    buckets[bucket_count] = @values.last
    @values.each do |val|
      while val > buckets[bi]
        bi += 1
      end
      if val <= buckets[bi]
        counts[bi] += 1
      end
    end

    [buckets, counts]
  end

  def percentile(pct)
    @values[(@count * pct).floor]
  end
end

Rlikestats.new.run
