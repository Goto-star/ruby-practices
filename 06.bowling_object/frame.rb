# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.sum
  end

  def strike?
    @shots.first == 10
  end

  def spare?
    @shots.size == 2 && shots.sum == 10
  end
end
