#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

lines = 0
words = 0
byte = 0

total_lines = []
total_words = []
total_byte = []

opt = OptionParser.new

params = {}

opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

if params[:l] && ARGV == []
  lines = 0
  ARGF.each do |stdin|
    lines += stdin.count("\n")
  end
  puts lines.to_s.rjust(8).to_s
elsif params[:l]
  ARGV.each do |file|
    File.open(file) do |file_name|
      lines = file_name.readlines
      puts "#{lines.size.to_s.rjust(8)} #{file}"

      total_lines << lines.size if ARGV.size >= 2

      puts "#{total_lines.sum.to_s.rjust(8)} total" if total_lines.size == ARGV.size
    end
  end
elsif ARGV == []
  ARGF.each do |stdin|
    lines += stdin.count("\n")
    words += stdin.scan(/\S+/).count
    byte += stdin.bytesize
  end
  puts lines.to_s.rjust(8) + words.to_s.rjust(8) + byte.to_s.rjust(8)
else
  ARGV.each do |file|
    File.open(file) do |file_name|
      lines = file_name.readlines
      words = 0
      lines.each do |line|
        words += line.scan(/\S+/).count
      end
      byte = File::Stat.new(file_name).size
      puts "#{lines.size.to_s.rjust(8)}#{words.to_s.rjust(8)}#{byte.to_s.rjust(8)} #{file}"

      if ARGV.size >= 2
        total_lines << lines.size
        total_words << words
        total_byte << byte
      end

      puts "#{total_lines.sum.to_s.rjust(8)}#{total_words.sum.to_s.rjust(8)}#{total_byte.sum.to_s.rjust(8)} total" if total_byte.size == ARGV.size
    end
  end
end
