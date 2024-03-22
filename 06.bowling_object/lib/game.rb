# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize(shot_pins)
    @frames = build_frames(shot_pins)
  end

  def score
    @frames.each_with_index.sum { |frame, idx| frame.score(@frames, idx) }
  end

  private

  def build_frames(shot_pins)
    @frames = []
    shot_pins.split(',').each do |pin|
      @frames = [*@frames, Frame.new] if frame_terminated?(@frames.last) && !last_frame?
      @frames.last.shots = @frames.last.add(pin)
    end
    @frames
  end

  def frame_terminated?(frame)
    frame.nil? || frame.strike? || frame.spare? || frame.shots.size == 2
  end

  def last_frame?
    @frames.size == 10
  end
end
