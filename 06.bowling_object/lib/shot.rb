# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'
  STRIKE_SCORE = 10

  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return STRIKE_SCORE if @mark == STRIKE_MARK
    mark.to_i
  end
end
