# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(pinfall_text)
    @frames = build_frames(pinfall_text)
  end

  def calc_score
    @frames.each_with_index.sum do |frame, index|
      if last_frame_index?(index)
        frame.score
      else
        following_shots = following_shots_from(index)
        frame.score + frame.bonus(following_shots)
      end
    end
  end

  private

  def build_frames(pinfall_text)
    shots = build_shots(pinfall_text)

    frames = []

    9.times do
      frames << (strike?(shots.first) ? Frame.new(shots.shift) : Frame.new(shots.shift, shots.shift))
    end

    frames << Frame.new(*shots)
  end

  def build_shots(pinfall_text)
    pinfall_text.split(',').map { |pinfall_str| Shot.new(pinfall_str) }
  end

  def strike?(shot)
    shot.pinfall == 10
  end

  def last_frame_index?(index)
    index == @frames.size - 1
  end

  def following_shots_from(index)
    @frames[(index + 1)..].map(&:shots).flatten
  end
end
