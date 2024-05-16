# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(*marks)
    @frames = create_frames(marks)
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      frame.score(@frames, index)
    end
  end

  private

  def create_frames(marks)
    flat_marks = marks.flatten
    shots = []
    flat_marks.each do |mark|
      shots << Shot.new(mark)
      shots << Shot.new('0') if mark == 'X'
    end

    shots.each_slice(2).map { |shot_group| Frame.new(shot_group) }
  end
end
