# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class TestBowlingScoreCalculation < Minitest::Test
  def test_no_bonus
    all_roll_result = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1'
    assert_equal 46, Game.new(all_roll_result).score
  end

  def test_spare_bonus
    all_roll_result = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,5,5,9,1,2'
    assert_equal 67, Game.new(all_roll_result).score
  end

  def test_strike_bonus
    all_roll_result = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,X,X,1,0'
    assert_equal 68, Game.new(all_roll_result).score
  end

  def test_all_strikes
    all_roll_result = 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, Game.new(all_roll_result).score
  end

  def test_last_frame_is_spare
    all_roll_result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    assert_equal 139, Game.new(all_roll_result).score
  end

  def test_last_frame_is_perfect
    all_roll_result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    assert_equal 164, Game.new(all_roll_result).score
  end

  def test_last_frame_took_2pitches
    all_roll_result = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, Game.new(all_roll_result).score
  end

  def test_last_frame_is_scoreless_after_strikes
    all_roll_result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    assert_equal 134, Game.new(all_roll_result).score
  end

  def test_last_frame_is_bonusless_scored_after_strike
    all_roll_result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    assert_equal 144, Game.new(all_roll_result).score
  end

  def test_all_strikes_except_the_last
    all_roll_result = 'X,X,X,X,X,X,X,X,X,X,X,2'
    assert_equal 292, Game.new(all_roll_result).score
  end

  def test_strike_but_no_bonus
    all_roll_result = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    assert_equal 50, Game.new(all_roll_result).score
  end
end
