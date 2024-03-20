# frozen_string_literal: true

class Shot
  attr_reader :pin

  STRIKE_MARK = 'X'

  def initialize(pin)
    @pin = convert_to_i(pin)
  end

  private

  def convert_to_i(pin)
    pin == STRIKE_MARK ? 10 : pin.to_i
  end
end
