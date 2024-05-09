# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shot_group)
    @shots = shot_group
    @frame_shots = @shots.map(&:pin)
  end

  def score(frames, index)
    frame_score = @frame_shots.sum
    if index < 9
      if strike?
        frame_score += calc_strike_bonus(frames, index)
      elsif spare?
        frame_score += calc_spare_bonus(frames, index)
      end
    end
    frame_score
  end

  def strike?
    @frame_shots.first == 10
  end

  def spare?
    @frame_shots.size == 2 && @frame_shots.sum == 10
  end

  private

  def calc_strike_bonus(frames, index)
    bonus_scores = []
    bonus_scores << frames[index + 1].shots[0]
    bonus_scores << if frames[index + 1].shots[0].pin == 10
                      frames[index + 2].shots[0]
                    else
                      frames[index + 1].shots[1]
                    end
    bonus_scores.map(&:pin).sum
  end

  def calc_spare_bonus(frames, index)
    frames[index + 1].shots[0].pin
  end
end
