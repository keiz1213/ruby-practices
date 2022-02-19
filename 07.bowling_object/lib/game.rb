# frozen_string_literal: true

class Game
  def initialize(marks)
    @frames = []
    marks.each do |mark|
      @frames << Frame.new(mark[0], mark[1])
    end
  end

  def calculate
    point = 0
    @frames.each_with_index do |frame, index|
      break if index == 10

      point += if frame.first_shot.mark == 'X' && @frames[index + 1].first_shot.mark == 'X'
                 20 + @frames[index + 2].first_shot.score
               elsif frame.first_shot.mark == 'X'
                 10 + @frames[index + 1].score
               elsif frame.score == 10
                 10 + @frames[index + 1].first_shot.score
               else
                 frame.score
               end
    end
    puts point
  end
end
