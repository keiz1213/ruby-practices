# frozen_string_literal: true

require_relative './command'
require_relative './shot'
require_relative './frame'
require_relative './game'

input = Command.new(ARGV[0])
marks = input.make_marks
game = Game.new(marks)
point = game.calculate
puts point
