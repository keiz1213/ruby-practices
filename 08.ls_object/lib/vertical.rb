# frozen_string_literal: true

require_relative './input'
require_relative './entry'
require_relative './container'

class Vertical
  attr_reader :container, :options

  def initialize(path, options)
    @container = Container.new(path)
    @options = options
  end

  def process(entries)
    entries = entries.delete_if { |entry| entry.name[0] == '.' } unless options[:a]
    entries.reverse! if options[:r]
    entries
  end

  def display
    entries = process(container.entries)
    max_name = entries.map { |entry| entry.name.size }.max
    if options[:l]
      container.output_lines(entries)
    else
      column_size = container.column_size(entries)
      rows = container.create_rows(column_size)
      container.output_rows(rows, max_name)
    end
  end
end
