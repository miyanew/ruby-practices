#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH_SUM_VALUE = 8

def main(args)
  options = {}
  options[:filepaths] = args[:filepaths] || args[:filepaths] = false
  options[:l]         = args[:l] || args[:l] = false
  options[:w]         = args[:w] || args[:w] = false
  options[:c]         = args[:c] || args[:c] = false

  if options[:filepaths].empty?
    show_totals_pipe_input(options)
  else
    show_totals_file_input(options)
  end
end

def show_totals_pipe_input(options)
  input_totals = count_input(readlines.join)
  show_result(input_totals, options)
end

def show_totals_file_input(options)
  input_totals_list = []
  options[:filepaths].each do |fp|
    input_totals = count_input(File.open(fp).readlines.join)
    show_result(input_totals, options, fp)
    input_totals_list << input_totals
  end
  show_total(input_totals_list, options) if input_totals_list.size > 1
end

def count_input(input_readline)
  {
    lines_count: input_readline.split("\n").size,
    words_count: input_readline.split("\s").size,
    bytes_count: input_readline.bytesize
  }
end

def show_result(count_results, options, counted_target = nil)
  showed_line = ''
  showed_line += adjust_show_width(count_results[:lines_count]) if show_lines?(options)
  showed_line += adjust_show_width(count_results[:words_count]) if show_words?(options)
  showed_line += adjust_show_width(count_results[:bytes_count]) if show_bytes?(options)
  showed_line += " #{counted_target}" unless counted_target.nil?
  puts showed_line
end

def show_total(input_totals_list, options)
  count_results_sum = {
    lines_count: input_totals_list.sum { |ret| ret[:lines_count] },
    words_count: input_totals_list.sum { |ret| ret[:words_count] },
    bytes_count: input_totals_list.sum { |ret| ret[:bytes_count] }
  }
  show_result(count_results_sum, options, 'total')
end

def adjust_show_width(sum)
  sum.to_s.rjust(WIDTH_SUM_VALUE)
end

def show_all?(options)
  !options[:l] && !options[:w] && !options[:c]
end

def show_lines?(options)
  options[:l] || show_all?(options)
end

def show_words?(options)
  options[:w] || show_all?(options)
end

def show_bytes?(options)
  options[:c] || show_all?(options)
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
