# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class TestBowlingScoreCalculation < Minitest::Test
  def test_no_bonus
    shot_marks = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1'
    assert_equal 46, Game.new(shot_marks).score
  end

  def test_spare_bonus
    shot_marks = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,5,5,9,1,2'
    assert_equal 67, Game.new(shot_marks).score
  end

  def test_strike_bonus
    shot_marks = '0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,X,X,1,0'
    assert_equal 68, Game.new(shot_marks).score
  end

  def test_all_strikes
    shot_marks = 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, Game.new(shot_marks).score
  end
end
