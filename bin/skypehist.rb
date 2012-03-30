#! /usr/bin/env ruby

# Usage
# skypehist.rb "query term" dbfile
# 
# where <dbfile> is main.db:
# find ~/Library/Application Support/Skype/ | grep main.db

require 'time'

require 'rubygems'
require 'sqlite3'

Message = Struct.new(:timestamp, :author, :message, :sendto) do
  def self.from_sqlite(str)
    timestamp, author, message, sendto = str
    new(timestamp, author, message, sendto)
  end

  def print
    formatted_timestamp = Time.at(timestamp.to_i).iso8601
    puts "%s %s >> %s" % [formatted_timestamp, author, sendto]
    puts "   %s" % message
  end
end

class SkypeHistorySearch
  def search(q, db_file)
    sql = "select timestamp, author, body_xml, dialog_partner from Messages where body_xml like '%#{q}%' order by timestamp desc;"

    db = SQLite3::Database.new(db_file)
    rows = db.execute(sql)
    rows.map do |line|
      Message.from_sqlite(line)
      
    end
  end
end

search_results = SkypeHistorySearch.new.search(query=ARGV.fetch(0), db_file=ARGV.fetch(1))

puts "==Found=="
search_results.each do |message|
  message.print
  puts
end
