# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
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

  def add(pins)
    @shots << Shot.new(pins)
  end

  def pins
    @shots.map(&:mark)
  end

  def strike?
    pins.first == 10
  end

  def spare?
    !strike? && pins.sum == 10
  end

  private

  def next_two_shots(frames, idx)
    frames[(idx + 1)..].flat_map(&:pins).first(2).sum
  end

  def next_one_shots(frames, idx)
    frames[(idx + 1)].pins.first
  end
end
