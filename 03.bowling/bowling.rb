#!/usr/bin/env ruby
# frozen_string_literal: false

score = ARGV[0]

# ボウリングの10フレーム分のスコアから合計得点を算出する
def score_calculation(scores)
  # スコア を 倒したピン数 に変換する
  shots = []
  scores.each do |s|
    if s == 'X' && shots.size < (9 * 2) # 9フレーム目までのストライク
      shots << 10
      shots << nil
    elsif s == 'X' # 10フレーム目のストライク
      shots << 10
    else
      shots << s.to_i
    end
  end

  # 倒したピン数をフレーム毎に分ける。10フレーム目に3投した場合、11フレームが出現するので補正する。
  frames = []
  shots.each_slice(2) do |s|
    frames << s
  end

  if frames.size > 10
    frames_tmp = frames[0..8]
    frames_tmp << frames[-2] + frames[-1]
    frames = frames_tmp
  end

  # 倒したピンの総数とボーナス点を加算して合計点をだす。ボーナス点があるのは9フレーム目まで。
  point = 0
  frames.each_with_index do |frame, idx|
    if (idx < 9) && (frame[0] == 10) # strike bonus
      shots_future = frames[(idx + 1)..].flatten.delete_if(&:nil?)
      point += shots_future[0..1].sum
    elsif (idx < 9) && (frame[0] != 10) && (frame.sum == 10) # spare bonus
      point += frames[idx + 1][0]
    end
    point += frame.delete_if(&:nil?).sum
  end
  p point
end

score_calculation(score.split(','))
