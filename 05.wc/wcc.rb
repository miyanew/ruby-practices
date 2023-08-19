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
  input_stats = [build_stats(readlines.join)]
  show_result(input_stats, options)
end

def show_stats_for_file_input(options)
  input_stats_list = options[:filepaths].map { |fp| build_stats(File.read(fp), fp) }
  show_result(input_stats_list, options)
  show_total(input_stats_list, options) if input_stats_list.size > 1
end

def build_stats(input_text, file_path = '')
  {
    lines_count: input_text.lines.size,
    words_count: input_text.split("\s").size,
    bytes_count: input_text.bytesize,
    file_path:
  }
end

def show_result(count_results, options)
  count_results.each do |count_result|
    puts build_line(count_result, options)
  end
end

def show_total(input_stats_list, options)
  totals = {
    lines_count: input_stats_list.sum { |ret| ret[:lines_count] },
    words_count: input_stats_list.sum { |ret| ret[:words_count] },
    bytes_count: input_stats_list.sum { |ret| ret[:bytes_count] },
    file_path: 'total'
  }
  puts build_line(totals, options)
end

def build_line(count_result, options)
  show_all = options.values_at(:l, :w, :c).none?
  line = ''
  line += adjust_width(count_result[:lines_count]) if options[:l] || show_all
  line += adjust_width(count_result[:words_count]) if options[:w] || show_all
  line += adjust_width(count_result[:bytes_count]) if options[:c] || show_all
  line += " #{count_result[:file_path]}" unless count_result[:file_path].nil?
  line
end

def adjust_width(sum)
  sum.to_s.rjust(WIDTH)
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
