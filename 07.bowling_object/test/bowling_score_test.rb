# frozen_string_literal: true

require 'minitest/autorun'
require './lib/command'
require './lib/shot'
require './lib/frame'
require './lib/game'

class BowlingScoreTest < Minitest::Test
  def test_input_pattern_one
    input = Command.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("139\n") { game.calculate }
  end

  def test_input_pattern_two
    input = Command.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("164\n") { game.calculate }
  end

  def test_input_pattern_three
    input = Command.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("107\n") { game.calculate }
  end

  def test_input_pattern_four
    input = Command.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("134\n") { game.calculate }
  end

  def test_input_pattern_five
    input = Command.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("144\n") { game.calculate }
  end

  def test_input_pattern_six
    input = Command.new('X,X,X,X,X,X,X,X,X,X,X,X')
    marks = input.make_marks
    game = Game.new(marks)
    assert_output("300\n") { game.calculate }
  end
end
