#!/usr/bin/env ruby
# frozen_string_literal: false

STRIKE_SCORES = 'X'.freeze
STRIKE_POINT = 10

# ボウリングの10フレーム分のスコアから合計得点を算出する
def calculate_score(scores)
  strike_or_otherwise = scores.slice_when { |i, j| [i, j].include?(STRIKE_SCORES) }

  # ストライクなら1投、それ以外は2投の結果をフレームごとにArray型でセットし、二次元配列にする。
  frames = strike_or_otherwise.flat_map do |frame|
    if frame.include?(STRIKE_SCORES)
      [[STRIKE_POINT]]
    else
      frame.map(&:to_i).each_slice(2).to_a
    end
  end

  # 10フレーム目にストライクがでた場合、11フレーム以降の結果としてセットされてしまうので10フレームにおさめる。
  frames = frames[0..8].push(frames[9..].flatten) if frames.size > 10

  # 倒したピンの総数とボーナス点を加算して合計点をだす。ボーナス点があるのは9フレーム目まで。
  point = 0
  frames.each_with_index do |frame, idx|
    point += frame.sum
    next if idx == 10

    if frame[0] == 10 # strike bonus
      shots_future = frames[(idx + 1)..].flatten
      point += shots_future[0..1].sum
    elsif frame.sum == 10 # spare bonus
      point += frames[idx + 1][0]
    end
  end
  point
end

if $PROGRAM_NAME == __FILE__
  score = ARGV[0]
  p calculate_score(score.split(','))
end
