#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH = 8

def main(options)
  if options[:filepaths].empty?
    show_stats_for_pipe_input(options)
  else
    show_stats_for_file_input(options)
  end
end

def show_stats_for_pipe_input(options)
  input_stats = [count_input(readlines.join)]
  show_result(input_stats, options)
end

def show_stats_for_file_input(options)
  input_stats_list = options[:filepaths].map do |fp|
    input_stats = count_input(File.read(fp))
    input_stats.merge(file_path: fp)
  end
  show_result(input_stats_list, options)
  show_total(input_stats_list, options) if input_stats_list.size > 1
end

def count_input(input_text)
  {
    lines_count: input_text.lines.size,
    words_count: input_text.split("\s").size,
    bytes_count: input_text.bytesize
  }
end

def show_result(count_results, options)
  count_results.each do |count_result|
    puts build_line(count_result, options, count_result[:file_path])
  end
end

def show_total(input_stats_list, options)
  totals = {
    lines_count: input_stats_list.sum { |ret| ret[:lines_count] },
    words_count: input_stats_list.sum { |ret| ret[:words_count] },
    bytes_count: input_stats_list.sum { |ret| ret[:bytes_count] }
  }
  puts build_line(totals, options, 'total')
end

def build_line(count_result, options, counted_target)
  line = ''
  line += adjust_width(count_result[:lines_count]) if options[:l] || show_all?(options)
  line += adjust_width(count_result[:words_count]) if options[:w] || show_all?(options)
  line += adjust_width(count_result[:bytes_count]) if options[:c] || show_all?(options)
  line += " #{counted_target}" unless counted_target.nil?
  line
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
