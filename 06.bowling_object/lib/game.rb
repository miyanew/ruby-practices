# frozen_string_literal: true

require_relative 'frame'

class Game
  STRIKE_MARK = 'X'

  attr_reader :frames

  def initialize(shot_marks)
    delimited_marks = parse_marks(shot_marks.split(','))
    @frames = delimited_marks.map { |m| Frame.new(m) }
  end

  def score
    pin_score = @frames.map(&:score).sum
    strike_bonus = calculate_strike_bonus
    spare_bonus = calculate_spare_bonus
    pin_score + strike_bonus + spare_bonus
  end

  private

  def parse_marks(all_marks)
    frames = []
    9.times do
      mark_pair = all_marks.shift(2)
      frames << (mark_pair.include?(STRIKE_MARK) ? [mark_pair.first] : mark_pair)
      all_marks.unshift(mark_pair.last) if mark_pair.include?(STRIKE_MARK)
    end

    frames << all_marks
  end

  def calculate_strike_bonus
    @frames.each_with_index.sum do |frame, idx|
      next 0 if idx == 9

      frame.strike? ? @frames[(idx + 1)..].map(&:pins).flatten.first(2).sum : 0
    end
  end

  def calculate_spare_bonus
    @frames.each_with_index.sum do |frame, idx|
      next 0 if idx == 9

      frame.spare? ? @frames[(idx + 1)].pins.first : 0
    end
  end
end
