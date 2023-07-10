# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'bowling'

class TestBowlingScoreCalculation < Minitest::Test
  def test_last_frame_is_spare
    scores = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 6, 4, 5]
    assert_equal 139, calculate_score(scores)
  end

  def test_last_frame_is_perfect
    scores = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 'X', 'X']
    assert_equal 164, calculate_score(scores)
  end

  def test_last_frame_took_2pitches
    scores = [0, 10, 1, 5, 0, 0, 0, 0, 'X', 'X', 'X', 5, 1, 8, 1, 0, 4]
    assert_equal 107, calculate_score(scores)
  end

  def test_last_frame_is_scoreless_after_strikes
    scores = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 0, 0]
    assert_equal 134, calculate_score(scores)
  end

  def test_last_frame_is_bonusless_scored_after_strike
    scores = [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 'X', 9, 1, 8, 0, 'X', 'X', 1, 8]
    assert_equal 144, calculate_score(scores)
  end

  def test_all_strikes
    scores = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
    assert_equal 300, calculate_score(scores)
  end
end
