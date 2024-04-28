#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/multi_column_output'
require_relative 'lib/long_format'

opt = OptionParser.new

args = {}
opt.on('-a') { |v| args[:a] = v }
opt.on('-r') { |v| args[:r] = v }
opt.on('-l') { |v| args[:l] = v }
opt.parse!(ARGV)

args[:path] = ARGV[0] || '.'

presenter = args[:l] ? LongFormat.new : MultiColumnOutput.new
puts presenter.show(target_path: args[:path], dot_match: args[:a], reverse: args[:r])
