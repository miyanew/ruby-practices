# frozen_string_literal: true

class Shot
  attr_reader :pin

  STRIKE_MARK = 'X'

  def initialize(pin)
    @pin = pin
  end

  def convert_to_i(pin)
    pin == STRIKE_MARK ? 10 : pin.to_i
  end
end
