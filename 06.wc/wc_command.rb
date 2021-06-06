#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

words = 0
byte = 0

total_lines = []
total_words = []
total_byte = []

opt = OptionParser.new

params = {}

opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

if ARGV == []
  lines = 0
  ARGF.each do |stdin|
    lines += stdin.count("\n")
    words += stdin.scan(/\S+/).count
    byte += stdin.bytesize
  end
  if params[:l]
    puts lines.to_s.rjust(8)
  else
    puts lines.to_s.rjust(8) + words.to_s.rjust(8) + byte.to_s.rjust(8)
  end
end

ARGV.each do |file|
  File.open(file) do |file_name|
    lines = file_name.readlines
    words = lines.sum { |line| line.scan(/\S+/).count }
    byte = File::Stat.new(file_name).size
  end

  if ARGV.size >= 2
    total_lines << lines.size
    total_words << words
    total_byte << byte
  end

  if params[:l]
    puts "#{lines.size.to_s.rjust(8)} #{file}"
    puts "#{total_lines.sum.to_s.rjust(8)} total" if total_lines.size == ARGV.size
  else
    puts "#{lines.size.to_s.rjust(8)}#{words.to_s.rjust(8)}#{byte.to_s.rjust(8)} #{file}"
    puts "#{total_lines.sum.to_s.rjust(8)}#{total_words.sum.to_s.rjust(8)}#{total_byte.sum.to_s.rjust(8)} total" if total_byte.size == ARGV.size
  end
end
