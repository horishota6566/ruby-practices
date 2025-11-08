# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize
    @shots = []
  end

  def closed?
    strike? || @shots.size == 2
  end

  def strike?
    @shots.first&.pinfall == 10
  end

  def spare?
    @shots.sum(&:pinfall) == 10
  end

  def add_shot(pinfall)
    @shots << Shot.new(pinfall)
  end
end
