#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' && shots.size < 18
    shots << 10
    shots << 0
  elsif s == 'X'
    shots << 10
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

if frames.size > 10
  frames_tmp = frames[0..8]
  frames_tmp << frames[-2] + frames[-1]
  frames = frames_tmp
end

point = 0
frames.each do |frame|
  if frame[0] == 10 # strike
    point += 30
  elsif frame.sum == 10 # spare
    point += frame[0] + 10
  else
    point += frame.sum
  end
end
puts point

