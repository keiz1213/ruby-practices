# frozen_string_literal: true

class Builder
  attr_reader :paths, :options

  def initialize(paths, options)
    @paths = paths
    @options = options
  end

  def build_entries
    if paths[0].ftype == 'file'
      paths.map { |path| Entry.new(path) }
    else
      pattern = paths[0].join('*')
      params = options[:a] ? [pattern, File::FNM_DOTMATCH] : [pattern]
      entries = Dir.glob(*params).sort.map { |name| Entry.new(name) }
      entries = entries.reverse if options[:r]
      entries
    end
  end
end
