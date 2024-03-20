# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  STRIKE_MARK = 'X'

  def initialize(shot_marks)
    @frame = Frame.new
    shot_pins = shot_marks.split(',').map do |mark|
      convert_to_i(mark)
    end
    @frames = build_frames(shot_pins)
  end

  def score
    @frame.calculate(self)
  end

  private

  def convert_to_i(mark)
    mark == STRIKE_MARK ? 10 : mark.to_i
  end

  def build_frames(shot_pins)
    @frame.build_frames(shot_pins)
  end
end
