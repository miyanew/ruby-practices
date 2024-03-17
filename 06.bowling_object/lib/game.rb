# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  STRIKE_MARK = 'X'

  def initialize(shot_marks)
    @frames = []
    shot_pins = shot_marks.split(',').map do |mark|
      convert_to_i(mark)
    end
    build_frames(shot_pins)
  end

  def score
    pin_score = @frames.sum(&:score)
    strike_bonus = calculate_strike_bonus
    spare_bonus = calculate_spare_bonus
    pin_score + strike_bonus + spare_bonus
  end

  private

  def convert_to_i(mark)
    mark == STRIKE_MARK ? 10 : mark.to_i
  end

  def build_frames(shot_pins)
    shot_pins.each do |pins|
      current_frame = @frames.last
      if frame_terminated?(current_frame) && !last_frame?
        current_frame = Frame.new
        @frames << current_frame
      end
      current_frame.add(pins)
    end
  end

  def frame_terminated?(current_frame)
    current_frame.nil? || current_frame.strike? || current_frame.spare? || current_frame.shots.size == 2
  end

  def last_frame?
    @frames.size == 10
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
