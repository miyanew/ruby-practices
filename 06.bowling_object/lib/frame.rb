# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_accessor :shots

  def initialize
    @shots = []
  end

  def add(pin)
    @shots = [*@shots, Shot.new(pin)]
  end

  def score(frames, idx)
    score = frames[idx].pins.sum
    if idx < 9
      score += next_two_shots(frames, idx) if frames[idx].strike?
      score += next_one_shots(frames, idx) if frames[idx].spare?
    end
    score
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

  def next_two_shots(frames, idx)
    frames[(idx + 1)..].flat_map(&:pins).first(2).sum
  end

  def next_one_shots(frames, idx)
    frames[(idx + 1)].pins.first
  end
end
