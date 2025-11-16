# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(pinfall_text)
    @pinfall_text = pinfall_text
    @frames = []
  end

  def calc_score
    pinfalls = parse_pinfall_text(@pinfall_text)
    pinfalls.each_with_index.sum do |pinfall, index|
      @frames << Frame.new if need_new_frame?(@frames)
      frame = @frames.last
      frame.add_shot(pinfall)
      following_pinfalls = pinfalls[index.succ..]
      has_last_frame?(@frames) ? pinfall : pinfall + add_bonus(frame, following_pinfalls)
    end
  end

  private

  def parse_pinfall_text(pinfall_text)
    pinfall_text.split(',').map { |c| c == 'X' ? 10 : c.to_i }
  end

  def need_new_frame?(frames)
    !has_last_frame?(frames) && (frames.empty? || frames.last.closed?)
  end

  def has_last_frame?(frames)
    frames.size == 10
  end

  def add_bonus(frame, following_pinfalls)
    if frame.strike?
      following_pinfalls.first(2).sum
    elsif frame.spare?
      following_pinfalls.first
    else
      0
    end
  end
end
