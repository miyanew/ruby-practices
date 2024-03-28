# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :number

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
      score += strike_bonus(frames[(@number + 1)..]) if strike?
      score += spare_bonus(frames[(@number + 1)]) if spare?
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
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end

  def strike_bonus(next_frames)
    next_two_shots = next_frames.flat_map(&:shots).first(2)
    next_two_shots.sum(&:score)
  end

  def spare_bonus(next_frame)
    next_frame.shots[0].score
  end
end
