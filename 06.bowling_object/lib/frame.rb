# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(number)
    @shots = []
    @number = number
  end

  def addable?
    @shots.empty? || (@shots.size == 1 && !strike?) || last_frame?
  end

  def add(pin)
    @shots << Shot.new(pin)
  end

  def score(frames)
    score = @shots.sum(&:score)
    if @number < 9
      following_frames = frames[(@number + 1)..]
      score += strike_bonus(following_frames) if strike?
      score += spare_bonus(following_frames[0]) if spare?
    end
    score
  end

  private

  def last_frame?
    @number == 9
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end

  def strike_bonus(following_frames)
    next_two_shots = following_frames.flat_map(&:shots).first(2)
    next_two_shots.sum(&:score)
  end

  def spare_bonus(following_frame)
    following_frame.shots[0].score
  end
end
