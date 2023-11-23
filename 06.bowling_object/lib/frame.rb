# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(marks)
    @shots = marks.map { |m| Shot.new(m)}
  end

  def score
    @shots.map(&:score).sum
  end
end
