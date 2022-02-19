# frozen_string_literal: true

require './lib/Command'
require './lib/Shot'
require './lib/Frame'
require './lib/Game'

input = Command.new(ARGV[0])
marks = input.make_marks
game = Game.new(marks)
game.calculate
