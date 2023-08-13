#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WIDTH_SUM_VALUES = 8

# Rubyでつくるwcコマンド
def main(args)
  options = {}
  options[:filepaths] = args[:filepaths] || args[:filepaths] = false
  options[:l]         = args[:l] || args[:l] = false
  options[:w]         = args[:w] || args[:w] = false
  options[:c]         = args[:c] || args[:c] = false

  standard_inputs = collect_inputs(options[:filepaths])
  totals_for_stdin = count_inputs(standard_inputs)
  show_result(totals_for_stdin, options)
end

def collect_inputs(filepaths)
  if filepaths.empty?
    stdin = {
      filepath: nil,
      body: readlines
    }
    [stdin]
  else
    filepaths.map do |fp|
      {
        filepath: fp,
        body: File.open(fp).readlines
      }
    end
  end
end

def count_inputs(standard_inputs)
  standard_inputs.map do |stdin|
    {
      source: stdin[:filepath] || stdin[:filepath] = nil,
      lines_count: stdin[:body].size,
      words_count: stdin[:body].join.split("\s").size,
      bytes_count: stdin[:body].join.bytesize
    }
  end
end

def show_result(count_results, options)
  count_results.each do |count_result|
    counted_target = count_result[:source] if show_filepath?(options)
    puts build_show_item(count_result, counted_target, options)
  end

  return unless count_results.size > 1

  count_results_sum = {
    lines_count: count_results.sum { |ret| ret[:lines_count] },
    words_count: count_results.sum { |ret| ret[:words_count] },
    bytes_count: count_results.sum { |ret| ret[:bytes_count] }
  }

  counted_target = 'total'
  showed_line = build_show_item(count_results_sum, counted_target, options)
  puts showed_line
end

def build_show_item(count_result, counted_target, options)
  showed_line = ''
  showed_line += adjust_show_width(count_result[:lines_count]) if showed_lines?(options)
  showed_line += adjust_show_width(count_result[:words_count]) if show_words?(options)
  showed_line += adjust_show_width(count_result[:bytes_count]) if show_bytes?(options)
  showed_line += " #{counted_target}" unless counted_target.nil?
  showed_line
end

def adjust_show_width(sum)
  sum.to_s.rjust(WIDTH_SUM_VALUES)
end

def showed_lines?(options)
  options[:l] || (!options[:l] && !options[:w] && !options[:c])
end

def show_words?(options)
  options[:w] || (!options[:l] && !options[:w] && !options[:c])
end

def show_bytes?(options)
  options[:c] || (!options[:l] && !options[:w] && !options[:c])
end

def show_filepath?(options)
  !options[:filepaths].empty?
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
