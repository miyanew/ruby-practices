#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

shot_marks = ARGV[0]
game = Game.new(shot_marks)
puts game.score
