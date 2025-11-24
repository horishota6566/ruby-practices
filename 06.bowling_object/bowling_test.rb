# frozen_string_literal: true

require_relative './lib/game'
require 'minitest/autorun'

class BowlingTest < Minitest::Test
  def test_calc_score139
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, game.calc_score
  end

  def test_calc_score164
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.calc_score
  end

  def test_calc_score107
    game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.calc_score
  end

  def test_calc_score134
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.calc_score
  end

  def test_calc_score144
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 144, game.calc_score
  end

  def test_calc_score300
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.calc_score
  end

  def test_calc_score292
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,2')
    assert_equal 292, game.calc_score
  end

  def test_calc_score50
    game = Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0')
    assert_equal 50, game.calc_score
  end
end
