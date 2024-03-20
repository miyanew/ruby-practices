# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_accessor :shots

  def initialize
    @shots = []
  end

  def build_frames(shot_pins)
    frames = []
    shot_pins.split(',').each do |pin|
      frames = [*frames, Frame.new] if frame_terminated?(frames.last) && !last_frame?(frames)
      frames.last.shots = [*frames.last.shots, Shot.new(pin)]
    end
    frames
  end

  def calculate(game)
    frames = game.frames
    total_score = 0
    frames.each_with_index do |frame, idx|
      total_score += frame.pins.sum
      next 0 if idx == 9

      total_score += next_two_shots(frames, idx) if frame.strike?
      total_score += next_one_shots(frames, idx) if frame.spare?
    end
    total_score
  end

  def pins
    @shots.map(&:pin)
  end

  def strike?
    pins.first == 10
  end

  def spare?
    !strike? && pins.sum == 10
  end

  private

  def frame_terminated?(frame)
    frame.nil? || frame.strike? || frame.spare? || frame.shots.size == 2
  end

  def last_frame?(frames)
    frames.size == 10
  end

  def next_two_shots(frames, idx)
    frames[(idx + 1)..].flat_map(&:pins).first(2).sum
  end

  def next_one_shots(frames, idx)
    frames[(idx + 1)].pins.first
  end
end
