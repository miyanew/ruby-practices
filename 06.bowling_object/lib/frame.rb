# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def score
    pins.sum
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
end
