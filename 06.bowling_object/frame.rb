# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shot1, shot2 = 0)
    @shots = build_frame(shot1, shot2)
  end

  def build_frame(shot1, shot2)
    frame = []
    frame << shot1.pin
    frame << if shot1.pin == 10
               shot2
             else
               shot2.pin
             end
  end

  def strike?
    @shots.first == 10
  end

  def spare?
    @shots.size == 2 && shots.sum == 10
  end

  def self.score(frames)
    @frames = frames
    frames.each_with_index.sum do |frame, index|
      frame_score = frame.shots.sum

      if index < 9
        if frame.strike?
          frame_score += calc_strike_bonus(index)
        elsif frame.spare?
          frame_score += calc_spare_bonus(index)
        end
      end

      frame_score
    end
  end

  def self.calc_strike_bonus(index)
    strike_bonus = 0
    strike_bonus += @frames[index + 1].shots[0]
    strike_bonus += if @frames[index + 1].strike?
                      @frames[index + 2].shots[0]
                    else
                      @frames[index + 1].shots[1]
                    end
    strike_bonus
  end

  def self.calc_spare_bonus(index)
    @frames[index + 1].shots[0]
  end

  private_class_method :calc_strike_bonus, :calc_spare_bonus
end
