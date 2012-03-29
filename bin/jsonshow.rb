#! /usr/bin/env ruby
# jsonshow.rb
# 
# Pretty prints JSON read from stdin:
# 
# $ echo '{"foo":["bar"]}' | jsonshow.rb 
# {
#   "foo": [
#     "bar"
#   ]
# }

require 'rubygems'
require 'json'

stdin = $stdin.read

result = stdin.gsub!(/\{.*\}/) do |json|
  (JSON.pretty_generate(JSON.parse(json))) rescue json
end

puts result
