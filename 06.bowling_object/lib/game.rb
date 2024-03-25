# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(shot_pins)
    @frames = build_frames(shot_pins)
  end

  def score
    @frames.sum { |frame| frame.score(@frames) }
  end

  private

  def build_frames(shot_pins)
    @frames = []
    shot_pins.split(',').each_with_index do |pin, idx|
      @frames = [*@frames, Frame.new(@frames.size)] if idx.zero? || @frames.last.terminated? && !last_frame?
      @frames.last.shots = @frames.last.add(pin)
    end
    @frames
  end

  def last_frame?
    @frames.size == 10
  end
end
