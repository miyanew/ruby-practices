# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  STRIKE_MARK = 'X'

  def initialize(shot_marks)
    @frame = Frame.new
    @frames = []
    shot_pins = shot_marks.split(',').map do |mark|
      convert_to_i(mark)
    end
    build_frames(shot_pins)
  end

  def score
    @frame.calculate(self)
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
end
