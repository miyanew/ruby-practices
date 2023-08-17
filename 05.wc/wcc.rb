#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main(args)
  options = {}
  options[:filepaths] = args[:filepaths] || args[:filepaths] = false
  options[:l]         = args[:l] || args[:l] = false
  options[:w]         = args[:w] || args[:w] = false
  options[:c]         = args[:c] || args[:c] = false

  if options[:filepaths].empty?
    show_stats_pipe_input(options)
  else
    show_stats_file_input(options)
  end
end

def show_stats_pipe_input(options)
  input_stats = count_input(readlines.join)
  show_result(input_stats, options)
end

def show_stats_file_input(options)
  input_stats_list = []
  options[:filepaths].each do |fp|
    input_stats = count_input(File.read(fp))
    show_result(input_stats, options, fp)
    input_stats_list << input_stats
  end
  show_total(input_stats_list, options) if input_stats_list.size > 1
end

def count_input(input_text)
  {
    lines_count: input_text.lines.size,
    words_count: input_text.split("\s").size,
    bytes_count: input_text.bytesize
  }
end

def show_result(count_results, options, counted_target = nil)
  line = ''
  line += adjust_width(count_results[:lines_count]) if options[:l] || show_all?(options)
  line += adjust_width(count_results[:words_count]) if options[:w] || show_all?(options)
  line += adjust_width(count_results[:bytes_count]) if options[:c] || show_all?(options)
  line += " #{counted_target}" unless counted_target.nil?
  puts line
end

def show_total(input_stats_list, options)
  totals = {
    lines_count: input_stats_list.sum { |ret| ret[:lines_count] },
    words_count: input_stats_list.sum { |ret| ret[:words_count] },
    bytes_count: input_stats_list.sum { |ret| ret[:bytes_count] }
  }
  show_result(totals, options, 'total')
end

def adjust_width(sum)
  sum.to_s.rjust(WIDTH)
end

def show_all?(options)
  !options[:l] && !options[:w] && !options[:c]
end

if $PROGRAM_NAME == __FILE__
  opt = OptionParser.new

  args = {}
  opt.on('-l') { |v| args[:l] = v }
  opt.on('-w') { |v| args[:w] = v }
  opt.on('-c') { |v| args[:c] = v }
  opt.parse!(ARGV)
  args[:filepaths] = ARGV

  main(args)
end
