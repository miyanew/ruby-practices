#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'

WIDTH_SUM_VALUES = 8

# Rubyでつくるwcコマンド
#   Done: コマンド引数からは、複数ファイルを指定可能にする
#   Done: パイプラインからも入力可能にする
#   Done: -lオプションを作る 行数をカウント
#   Done: -wオプションを作る 単語数をカウント
#   Done: -cオプションを作る バイト数をカウント
def main(args)
  options = {}
  options[:filepaths] = args[:filepaths] ||= false
  options[:l]         = args[:l] ||= false
  options[:w]         = args[:w] ||= false
  options[:c]         = args[:c] ||= false

  input_params = correct_inputs(options[:filepaths])
  input_params = count_inputs(input_params)
  show_result(input_params)
end

def correct_inputs(filepaths)
  result = []
  if filepaths.empty?
    stdin = {}
    stdin[:filepath] = nil
    stdin[:body] = readlines.map(&:chomp)
    result << stdin
  else
    filepaths.each do |fp|
      input_file = {}
      input_file[:filepath] = fp
      input_file[:body] = File.open(fp) { |f| f.readlines.map(&:chomp) }
      result << input_file
    end
  end
  result
end

def count_inputs(input_params)
  input_params.each do |input_param|
    result_count_to_body = []

    input_param[:body].map do |row|
      ret = {}
      ret[:lines_count] = 1
      ret[:words_count] = count_devide_by_space(row)
      ret[:bytes_count] = count_bytesize_with_linefeed(row)
      result_count_to_body << ret
    end

    input_param[:lines_count] = result_count_to_body.map { |ret| ret[:lines_count] }.sum
    input_param[:words_count] = result_count_to_body.map { |ret| ret[:words_count] }.sum
    input_param[:bytes_count] = result_count_to_body.map { |ret| ret[:bytes_count] }.sum
  end
end

def count_devide_by_space(input_line)
  input_line.split("\s").size
end

# zshの標準出力と揃えるため、末尾に改行コードを付与する
def count_bytesize_with_linefeed(input_line)
  input_line.bytesize + "\n".bytesize
end

def show_result(count_results)
  count_results.each do |count_result|
    lines_sum = adjust_show_width(count_result[:lines_count])
    words_sum = adjust_show_width(count_result[:words_count])
    bytes_sum = adjust_show_width(count_result[:bytes_count])

    show_line = "#{lines_sum}#{words_sum}#{bytes_sum}"
    show_line << " #{count_result[:filepath]}" unless count_result[:filepath].nil?
    puts show_line
  end

  return unless count_results.size > 1

  lines_sum_total = adjust_show_width(count_results.map.sum { |line| line[:lines_count] })
  words_sum_total = adjust_show_width(count_results.map.sum { |line| line[:words_count] })
  bytes_sum_total = adjust_show_width(count_results.map.sum { |line| line[:bytes_count] })

  show_line = "#{lines_sum_total}#{words_sum_total}#{bytes_sum_total} total"
  puts show_line
end

def adjust_show_width(sum_string)
  space = ' '
  sum_string.to_s.rjust(WIDTH_SUM_VALUES, space)
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
