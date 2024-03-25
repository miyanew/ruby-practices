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
    frames = []
    shot_pins.split(',').each_with_index do |pin, idx|
      frames = [*frames, Frame.new(frames.size)] if idx.zero? || frames[-1].two_shots_done? && !frames[-1].last_frame?
      frames[-1].add(pin)
    end
    frames
  end
end
