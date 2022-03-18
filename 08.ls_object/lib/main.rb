# frozen_string_literal: true

require_relative './vertical'

input = Input.new(ARGV)
path = input.path
options = input.options
vertical = Vertical.new(path, options)
vertical.display
