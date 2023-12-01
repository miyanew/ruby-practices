# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(marks)
    @shots = marks.map { |m| Shot.new(m) }
  end

  def score
    @shots.sum(&:score)
  end

  def pins
    @shots.map(&:score)
  end

  def strike?
    @shots.first.score == 10
  end

  def spare?
    !strike? && @shots.first(2).map(&:score).sum == 10
  end
end
