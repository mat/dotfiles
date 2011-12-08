require 'benchmark'
require 'open-uri'

require 'rubygems'
require 'active_support/all'
require 'nokogiri'


IRB.conf[:USE_READLINE] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE
require 'irb/completion'
IRB.conf[:AUTO_INDENT]=true
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

module Kernel
  def methodz
    self.methods - Object.methods
  end

  def profile2file(filename = "profile-#{Time.now.to_i}")
    require 'ruby-prof'
    block_result = nil
    profile_result = ::RubyProf.profile do
      block_result = yield
    end

    File.open("#{filename}.txt" , "w") { |file| ::RubyProf::FlatPrinter.new(profile_result).print(file) }
    File.open("#{filename}.html", "w") { |file| ::RubyProf::GraphHtmlPrinter.new(profile_result).print(file) }
    $stderr.puts("Find profile results in #{File.expand_path(filename)}.[txt|html]")

    block_result
  end
end

