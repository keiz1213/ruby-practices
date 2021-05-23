#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
require 'etc'

def calculate_bolocks(files)
  total = 0
  files.each do |file|
    total += File.stat(file).blocks
  end
  puts "total #{total}"
end

def gsub_date(split_date)
  split_date[1].gsub!('0', ' ') if split_date[1][0] == '0'
  split_date[2].gsub!('0', ' ') if split_date[2][0] == '0'
end

def reconstruct(split_date, mtime)
  if split_date[0].to_i < Date.today.year.to_i
    "#{split_date[1]} #{split_date[2]} #{(split_date[0]).to_s.rjust(5)}"
  else
    "#{split_date[1]} #{split_date[2]} #{mtime[1]}"
  end
end

def to_permission(mode)
  if mode.start_with?('40')
    mode.gsub!(/^40/, 'd')
  elsif mode.start_with?('100')
    mode.gsub!(/^100/, '-')
  end
  mode.gsub!(/\d/, '7' => 'rwx', '6' => 'rw-', '5' => 'r-x', '4' => 'r--', '3' => '-wx', '2' => '-w-', '1' => '--x',
                   '0' => '---')
end

def calculate_column_size(files)
  if (files.size % 3).zero?
    files.size / 3 + 1
  else
    files.size / 3 + files.size % 3
  end
end

opt = OptionParser.new
params = {}
opt.on('-a') { |v| params[:a] = v }
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }

opt.parse!(ARGV)

files = Dir.open('.').each.to_a.sort

files.delete_if { |x| x[0] == '.' } unless params[:a]
files.reverse! if params[:r]

if params[:l]
  calculate_bolocks(files)
  files.each do |file|
    file_stat = File::Stat.new(file)
    mode = to_permission(file_stat.mode.to_s(8))
    nlink = file_stat.nlink.to_s.rjust(2)
    user_name = Etc.getpwuid(file_stat.uid).name.to_s
    group_name = Etc.getgrgid(file_stat.gid).name.to_s
    name_size = 'nakamurakeizou'.size
    file_size = file_stat.size.to_s
    mtime = file_stat.mtime.to_s.split(' ')
    mtime[1].slice!(/.{1,3}$/)
    split_date = mtime[0].split('-')

    gsub_date(split_date)

    new_mtime = reconstruct(split_date, mtime)

    puts "#{mode} #{nlink} #{user_name.ljust(name_size)}  #{group_name} #{file_size.rjust(5)} #{new_mtime} #{file}"
  end
else
  string_sizes = []

  files.each do |file|
    string_sizes << file.size
  end

  max_size = string_sizes.max

  first_column_size = calculate_column_size(files)
  rows = files.each_slice(first_column_size).to_a

  rows.each do |row|
    next unless row.size < first_column_size

    (first_column_size - row.size).times do
      row << ' '
    end
  end

  rows.transpose.each do |new_line|
    new_line.each do |file_name|
      print file_name.ljust(max_size + 4)
    end
    print "\n"
  end
end
