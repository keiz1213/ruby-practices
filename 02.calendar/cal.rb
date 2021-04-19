#!/usr/bin/env ruby
require 'date'
require 'optparse'
options = ARGV.getopts('y:','m:')

if options['y'].nil? && options['m'].nil?
  options['y'] = Date.today.year
  options['m'] = Date.today.month
elsif options['y'].nil?
  options['y'] = Date.today.year
elsif options['m'].nil?
  options['m'] = Date.today.month
end

year = options['y'].to_i
month = options['m'].to_i
today = Date.today
start_day = Date.new(year,month,1)
end_day = Date.new(year,month,-1)
days = (start_day.day..end_day.day)

wday = start_day.wday
space = wday * 3
first_week = 7 - wday
second_week = first_week + 7
third_week = first_week + (7 * 2)
fourth_week = first_week + (7 * 3)
fifth_week = first_week + (7 * 4)

puts "#{month}月".rjust(8) + " " + "#{year}"
puts "日 月 火 水 木 金 土"
print " " * space
days.each do |day|
  if day == today.day && today.year == year && today.month == month
    print "\e[7m#{today.day}\e[0m".rjust(2) + " "
  else
    print day.to_s.rjust(2) + " "
  end
  case day
  when first_week,second_week,third_week,fourth_week,fifth_week
    print "\n"
  end
end
print "\n"
