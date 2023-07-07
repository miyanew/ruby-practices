#!/usr/bin/env ruby
# frozen_string_literal: false

STRIKE_SCORES = 10

# ボウリングの10フレーム分のスコアから合計得点を算出する
def calculate_score(scores)
  # スコア を 倒したピン数 に変換する
  shots = []
  scores.each do |s|
    if s == 'X' && shots.size < (9 * 2) # 9フレーム目までのストライク
      shots << STRIKE_SCORES
      shots << nil
    elsif s == 'X' # 10フレーム目のストライク
      shots << STRIKE_SCORES
    else
      shots << s.to_i
    end
  end

  # 倒したピン数をフレーム毎に分ける。10フレーム目に3投した場合、11フレームが出現するので補正する。
  frames = shots.each_slice(2).map(&:compact)

  if frames.size > 10
    frames_tmp = frames[0..8]
    frames_tmp << frames[-2] + frames[-1]
    frames = frames_tmp
  end

  # 倒したピンの総数とボーナス点を加算して合計点をだす。ボーナス点があるのは9フレーム目まで。
  point = 0
  frames.each_with_index do |frame, idx|
    if idx < 9
      if frame[0] == 10 # strike bonus
        shots_future = frames[(idx + 1)..].flatten
        point += shots_future[0..1].sum
      elsif frame.sum == 10 # spare bonus
        point += frames[idx + 1][0]
      end
    end
    point += frame.sum
  end
  point
end

if $PROGRAM_NAME == __FILE__
  score = ARGV[0]
  p calculate_score(score.split(','))
end
