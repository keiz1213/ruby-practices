# frozen_string_literal: true

require_relative './input'
require_relative './entry'
require_relative './entries_builder'

class VerticalOutput
  attr_reader :entries_builder, :options

  def initialize(path, options)
    @entries_builder = EntriesBuilder.new(path, options)
    @options = options
  end

  def display
    entries = entries_builder.build_entries
    if options[:l]
      output_lines(entries)
    else
      column_size = column_size(entries)
      rows = create_rows(column_size, entries)
      max_name = entries.map { |entry| entry.name.size }.max
      output_rows(rows, max_name)
    end
  end

  def column_size(entries)
    size = entries.size
    if (size % 3).zero?
      size / 3 + 1
    else
      size / 3 + size % 3
    end
  end

  def create_rows(column_size, entries)
    rows = entries.each_slice(column_size).to_a
    rows[0].zip(*rows[1..])
  end

  def output_rows(rows, max_name)
    rows.each do |row|
      row.each do |entry|
        next if entry.nil?

        print entry.name.ljust(max_name + 5)
      end
      print "\n"
    end
  end

  def output_lines(entries)
    if entries_builder.paths[0].ftype == 'directory'
      total = entries.map(&:blocks).sum
      puts "total #{total}"
    end
    link_max = entries.map { |entry| entry.link.size }.max
    owner_max = entries.map { |entry| entry.owner.size }.max
    group_max = entries.map { |entry| entry.group.size }.max
    file_size_max = entries.map { |entry| entry.file_size.size }.max
    entries.each { |entry| puts entry.line(link_max, owner_max, group_max, file_size_max) }
  end
end
