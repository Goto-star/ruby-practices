# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(*marks)
    @frames = build_frames(marks)
  end

  def build_frames(marks)
    shots = marks.flatten.map { |mark| Shot.new(mark).pin }
    @frames = shots.flatten.each_slice(2).to_a.map do |shot|
      Frame.new(shot)
    end
  end

  def score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.score
      if frame.strike? && index < 9
        total_score += calc_strike_bonus(index)
      elsif frame.spare? && index < 9
        total_score += calc_spare_bonus(index)
      end
    end
    total_score
  end

  private

  def calc_strike_bonus(index)
    strike_bonus = 0
    strike_bonus += @frames[index + 1].shots[0]
    strike_bonus += if @frames[index + 1].shots[0] == 10
                      @frames[index + 2].shots[0]
                    else
                      @frames[index + 1].shots[1]
                    end
    strike_bonus
  end

  def calc_spare_bonus(index)
    spare_bonus = 0
    spare_bonus += @frames[index + 1].shots[0]
    spare_bonus
  end
end
