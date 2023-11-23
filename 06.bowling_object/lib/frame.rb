# frozen_string_literal: true

require_relative 'shot'

class Frame
  STRIKE_SCORE = 10

  attr_reader :shots

  def initialize(marks)
    @shots = marks.map { |m| Shot.new(m) }
  end

  def score
    @shots.map(&:score).sum
  end

  def pins
    @shots.map(&:score)
  end

  def strike?
    @shots.first.score == STRIKE_SCORE
  end

  def spare?
    !strike? && @shots.first(2).map(&:score).sum == STRIKE_SCORE
  end
end
