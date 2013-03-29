#! /usr/bin/env ruby
# jsonpretty.rb
# 
# Pretty prints JSON read from stdin:
# 
# $ echo '{"foo":["bar"]}' | jsonpretty.rb 
# {
#   "foo": [
#     "bar"
#   ]
# }

require 'rubygems'
require 'json'

stdin = $stdin.read

result = stdin.gsub!(/\{.*\}/m) do |json|
  (JSON.pretty_generate(JSON.parse(json))) rescue json
end

puts result
