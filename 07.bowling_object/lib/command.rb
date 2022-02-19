# frozen_string_literal: true

class Command
  def initialize(input)
    @input = input
  end

  def make_marks
    marks = @input.split(',')
    marks.each_with_index do |mark, index|
      marks.insert(index + 1, '0') if mark == 'X'
    end
    marks.each_slice(2).to_a
  end
end
