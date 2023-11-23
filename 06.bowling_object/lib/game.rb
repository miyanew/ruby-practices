# frozen_string_literal: true

require_relative 'frame'

class Game
  STRIKE_MARK = 'X'

  attr_reader :frames

  def initialize(shot_marks)
    delimited_marks = parse_marks(shot_marks.split(','))
    @frames = delimited_marks.map { |m| Frame.new(m)}
  end

  def score
    pin_score = @frames.map(&:score).sum
    # spare_bonus
    # strike_bonus
    pin_score
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
end
