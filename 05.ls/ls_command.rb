#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'
require 'etc'

def calculate_bolocks(files)
  total = files.map { |file| File.stat(file).blocks }.sum
  puts "total #{total}"
end

def gsub_date(split_date)
  split_date[1].gsub!('0', ' ') if split_date[1][0] == '0'
  split_date[2].gsub!('0', ' ') if split_date[2][0] == '0'
end

def reconstruct(split_date, mtime)
  time = "#{split_date[1]} #{split_date[2]}"
  "#{time} " + if split_date[0].to_i < Date.today.year.to_i
                 split_date[0].to_s.rjust(5)
               else
                 mtime[1].to_s
               end
end

def change_file_type(mode)
  if mode.start_with? '40'
    'd'
  else
    '-'
  end
end

def slice_mode(mode)
  if mode.start_with? '40'
    mode.slice(2..4)
  else
    mode.slice(3..5)
  end
end

def change_permission(new_mode)
  permissions = new_mode.chars.map do |permission|
    {
      '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
    }[permission]
  end
  permissions.join
end

def string_max_size(files)
  files.map { |file| file.size }.max
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
    mode = file_stat.mode.to_s(8)
    new_mode = slice_mode(mode)
    attribute = "#{change_file_type(mode)}#{change_permission(new_mode)}"
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

    puts "#{attribute} #{nlink} #{user_name.ljust(name_size)}  #{group_name} #{file_size.rjust(5)} #{new_mtime} #{file}"
  end
else
  first_column_size = calculate_column_size(files)
  rows = files.each_slice(first_column_size).to_a
  max_size = string_max_size(files)

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
