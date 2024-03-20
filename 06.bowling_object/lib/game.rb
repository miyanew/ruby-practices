# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(shot_pins)
    @frame = Frame.new
    @frames = build_frames(shot_pins)
  end

  def score
    @frame.calculate(self)
  end

  private

  def build_frames(shot_pins)
    @frame.build_frames(shot_pins)
  end
end
