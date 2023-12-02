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
    frame = []
    all_marks.each do |mark|
      return [*frames, all_marks[(all_marks.size - frames.flatten.size) * -1..].dup] if last_frame?(frames)

      frame << mark
      if frame_terminated?(frame)
        frames << frame.dup
        frame.clear
      end
    end
  end

  def frame_terminated?(frame)
    frame.last == 'X' || frame.last == '10' || frame.size == 2
  end

  def last_frame?(frames)
    frames.size == 9
  end

  def calculate_strike_bonus
    @frames.each_with_index.sum do |frame, idx|
      next 0 if idx == 9

      frame.strike? ? @frames[(idx + 1)..].flat_map(&:pins).first(2).sum : 0
    end
  end

  def calculate_spare_bonus
    @frames.each_with_index.sum do |frame, idx|
      next 0 if idx == 9

      frame.spare? ? @frames[(idx + 1)].pins.first : 0
    end
  end
end
