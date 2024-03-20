# frozen_string_literal: true

class Shot
  attr_reader :mark

  STRIKE_MARK = 'X'

  def initialize(mark)
    @mark = convert_to_i(mark)
  end

  private

  def convert_to_i(mark)
    mark == STRIKE_MARK ? 10 : mark.to_i
  end
end
