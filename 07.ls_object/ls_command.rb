#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'lib/multi_column_format'
require_relative 'lib/long_format'

def main(opts)
  dir_entry_paths = collect_dir_entry_paths(opts[:path], opts[:a])
  sorted_entry_paths = opts[:r] ? dir_entry_paths.reverse : dir_entry_paths
  presenter = opts[:l] ? LongFormat : MultiColumnFormat
  presenter.new(sorted_entry_paths, opts[:path]).show()
end

def collect_dir_entry_paths(target_path, dot_match)
  flags = dot_match ? File::FNM_DOTMATCH : 0
  File.directory?(target_path) ? Dir.glob(File.join(target_path, '*'), flags) : [target_path]
end

if $PROGRAM_NAME == __FILE__
  opt = OptionParser.new
  args = {}
  opt.on('-a') { |v| args[:a] = v }
  opt.on('-r') { |v| args[:r] = v }
  opt.on('-l') { |v| args[:l] = v }
  opt.parse!(ARGV)
  args[:path] = ARGV[0] || '.'

  main(args)
end
