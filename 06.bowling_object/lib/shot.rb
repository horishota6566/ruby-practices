# frozen_string_literal: true

class Shot
  attr_reader :pinfall

  def initialize(pinfall_str)
    @pinfall = pinfall_str == 'X' ? 10 : pinfall_str.to_i
  end
end
