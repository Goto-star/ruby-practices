# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(*marks)
    @frames = create_frames(marks)
  end

  def score
    Frame.score(@frames)
  end

  private

  def create_frames(marks)
    shots = marks.flatten.map { |mark| Shot.new(mark) }
    frames = []
    i = 0

    while i < shots.length
      if shots[i].pin == 10
        frames << Frame.new(shots[i])
        i += 1
      elsif i + 1 < shots.length
        frames << Frame.new(shots[i], shots[i + 1])
        i += 2
      else
        frames << Frame.new(shots[i])
        i += 1
      end
    end

    frames
  end
end
