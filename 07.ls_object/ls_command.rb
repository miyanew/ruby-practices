#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/file_list_presenter'

opt = OptionParser.new

args = {}
opt.on('-a') { |v| args[:a] = v }
opt.on('-r') { |v| args[:r] = v }
opt.on('-l') { |v| args[:l] = v }
opt.parse!(ARGV)

args[:path] = ARGV[0] || '.'

puts FileListPresenter.new(args).show_file_list
