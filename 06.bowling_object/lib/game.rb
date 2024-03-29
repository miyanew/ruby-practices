# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(all_roll_result)
    @frames = build_frames(all_roll_result)
  end

  def score
    @frames.sum { |frame| frame.score(@frames) }
  end

  private

  def build_frames(all_roll_result)
    frames = []
    current_frame = nil
    all_roll_result.split(',').each do |pin|
      if current_frame.nil? || current_frame.addable? && !current_frame.last_frame?
        current_frame = Frame.new(frames.size)
        frames << current_frame
      end
      current_frame.add(pin)
    end
    frames
  end
end
