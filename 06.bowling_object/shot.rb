# frozen_string_literal: true

class Shot
  attr_reader :pin

  def initialize(mark)
    @pin = convert_marks_to_pins(mark)
  end

  private

  def convert_marks_to_pins(mark)
    return 10 if mark == 'X'

    mark.to_i
  end
end
