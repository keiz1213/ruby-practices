# frozen_string_literal: true

class Command
  def initialize(input)
    @input = input
  end

  def make_marks
    marks = @input.split(',')
    marks.map! { |mark| mark == 'X' ? [mark, 0] : mark }.flatten!
    marks.each_slice(2).to_a
  end
end
