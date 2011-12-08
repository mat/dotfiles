#! /usr/bin/env ruby
# jsonshow.rb

require 'rubygems'
require 'json'

stdin = $stdin.read

result = stdin.gsub!(/\{.*\}/) do |json|
  (JSON.pretty_generate(JSON.parse(json))) rescue json
end

puts result
