# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shot_group)
    @shots = shot_group
  end

  def score(frames, frame, index)
    frame_shots = frame.shots.map(&:pin)
    frame_score = 0
    frame_score += frame_shots.sum
    if index < 9
      if strike?(frame_shots)
        frame_score += calc_strike_bonus(frames, index)
      elsif spare?(frame_shots)
        frame_score += calc_spare_bonus(frames, index)
      end
    end
    frame_score
  end

  private

  def strike?(frame_shots)
    frame_shots.first == 10
  end

  def spare?(frame_shots)
    frame_shots.size == 2 && frame_shots.sum == 10
  end

  def calc_strike_bonus(frames, index)
    strike_bonus = 0
    strike_bonus += frames[index + 1].shots.map(&:pin)[0]
    strike_bonus += if frames[index + 1].shots.map(&:pin)[0] == 10
                      frames[index + 2].shots.map(&:pin)[0]
                    else
                      frames[index + 1].shots.map(&:pin)[1]
                    end
    strike_bonus
  end

  def calc_spare_bonus(frames, index)
    frames[index + 1].shots.map(&:pin)[0]
  end
end
