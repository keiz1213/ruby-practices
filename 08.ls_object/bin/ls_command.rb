# frozen_string_literal: true

require_relative '../lib/vertical_output'

input = Input.new(ARGV)
paths = input.paths
options = input.options
output = VerticalOutput.new(paths, options)
output.display
