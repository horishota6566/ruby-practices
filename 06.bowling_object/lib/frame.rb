# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(*shots)
    @shots = shots
  end

  def score
    @shots.sum(&:pinfall)
  end

  def bonus(following_shots)
    if strike?
      following_shots.first(2).sum(&:pinfall)
    elsif spare?
      following_shots.first.pinfall
    else
      0
    end
  end

  def strike?
    @shots.first.pinfall == 10
  end

  def spare?
    !strike? && @shots.sum(&:pinfall) == 10
  end
end
