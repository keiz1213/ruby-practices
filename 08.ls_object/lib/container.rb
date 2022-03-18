# frozen_string_literal: true

class Container
  attr_reader :entries

  def initialize(path)
    @entries = Dir.entries(path).sort.map { |name| Entry.new(name) }
  end

  def column_size(entries)
    size = entries.size
    if (size % 3).zero?
      size / 3 + 1
    else
      size / 3 + size % 3
    end
  end

  def create_rows(column_size)
    rows = entries.each_slice(column_size).to_a
    rows.map do |row|
      next unless row.size < column_size

      (column_size - row.size).times do
        row << ' '
      end
    end
    rows.transpose
  end

  def output_rows(rows, max_name)
    rows.each do |row|
      row.each do |entry|
        next if entry == ' '

        print entry.name.ljust(max_name + 5)
      end
      print "\n"
    end
  end

  def output_lines(entries)
    total = entries.map(&:blocks).sum
    puts "total #{total}"
    link_max = entries.map { |entry| entry.link.size }.max
    owner_max = entries.map { |entry| entry.owner.size }.max
    group_max = entries.map { |entry| entry.group.size }.max
    file_size_max = entries.map { |entry| entry.file_size.size }.max
    entries.each { |entry| puts entry.line(link_max, owner_max, group_max, file_size_max) }
  end
end
