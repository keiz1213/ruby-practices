#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]

scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0

frames.each_with_index do |frame, index|
  last_frame = index == 9
  last_frame_strike = last_frame && frames[9][0] == 10
  last_frame_spare = last_frame && frames[9].sum == 10
  if last_frame_strike && frames[10][0] == 10 && frames[11][0] == 10
    point += 30
    break
  elsif last_frame_strike && frames[10][0] == 10
    point += 20 + frames[11][0]
    break
  elsif last_frame_strike
    point += 10 + frames[10].sum
    break
  elsif last_frame_spare
    point += 10 + frames[10][0]
    break
  elsif frame[0] == 10 && frames[index + 1][0] == 10
    point += 20 + frames[index + 2][0]
  elsif frame[0] == 10
    point += 10 + frames[index + 1].sum
  elsif frame.sum == 10
    point += 10 + frames[index + 1][0]
  else
    point += frame.sum
  end
end
puts point
