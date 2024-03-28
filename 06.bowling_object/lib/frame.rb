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
    score = @shots.sum(&:score)
    if @number < 9
      score += next_two_shots(frames, @number) if strike?
      score += next_one_shots(frames, @number) if spare?
    end
    score
  end

  def two_shots_done?
    strike? || spare? || @shots.size == 2
  end

  def last_frame?
    @number == 9
  end

  private

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end

  def next_two_shots(frames, idx)
    frames[(idx + 1)..].flat_map(&:shots).first(2).sum(&:score)
  end

  def next_one_shots(frames, idx)
    frames[(idx + 1)].shots[0].score
  end
end
