# frozen_string_literal: true

require 'optparse'

class Input
  attr_reader :argv, :options

  def initialize(argv)
    @argv = argv

    opt = OptionParser.new
    params = {}
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse!(ARGV)

    @options = params
  end

  def path
    if argv[0].nil?
      Dir.pwd
    elsif Dir.pwd != argv[0]
      Dir.chdir(argv[0])
      Dir.pwd
    end
  end
end
