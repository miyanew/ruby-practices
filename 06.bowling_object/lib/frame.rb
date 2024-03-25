# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_accessor :shots
  attr_reader :number

  def initialize(number)
    @shots = []
    @number = number
  end

  def add(pin)
    @shots = [*@shots, Shot.new(pin)]
  end

  def score(frames)
    score = pins.sum
    if @number < 9
      score += next_two_shots(frames, @number) if strike?
      score += next_one_shots(frames, @number) if spare?
    end
    score
  end

  def pins
    @shots.map(&:score)
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
