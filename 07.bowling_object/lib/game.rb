# frozen_string_literal: true

class Game
  def initialize(marks)
    @frames = marks.map { |mark| Frame.new(mark[0], mark[1]) }
  end

  def calculate
    @frames[0..9].each_with_index.sum do |frame, index|
      if frame.first_shot.mark == 'X' && @frames[index + 1].first_shot.mark == 'X'
        20 + @frames[index + 2].first_shot.score
      elsif frame.first_shot.mark == 'X'
        10 + @frames[index + 1].score
      elsif frame.score == 10
        10 + @frames[index + 1].first_shot.score
      else
        frame.score
      end
    end
  end
end
