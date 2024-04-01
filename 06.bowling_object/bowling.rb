#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

all_roll_result = ARGV[0]
game = Game.new(all_roll_result)
puts game.score
