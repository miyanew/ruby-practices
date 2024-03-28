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
    current_frame = nil
    shot_pins.split(',').each do |pin|
      if current_frame.nil? || current_frame.addable? && !current_frame.last_frame?
        current_frame = Frame.new(frames.size)
        frames << current_frame
      end
      current_frame.add(pin)
    end
    frames
  end
end
