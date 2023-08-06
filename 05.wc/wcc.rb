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
  show_result(input_params, options)
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

def show_result(count_results, options)
  count_results.each do |count_result|
    show_item = {}
    show_item[:lines] = adjust_show_width(count_result[:lines_count])
    show_item[:words] = adjust_show_width(count_result[:words_count])
    show_item[:bytes] = adjust_show_width(count_result[:bytes_count])
    show_item[:filepath] = count_result[:filepath]

    show_line = build_show_item(show_item, options)
    show_line << " #{show_item[:filepath]}" unless show_item[:filepath].nil?
    puts show_line
  end

  return unless count_results.size > 1

  show_item = {}
  show_item[:lines] = adjust_show_width(count_results.map.sum { |line| line[:lines_count] })
  show_item[:words] = adjust_show_width(count_results.map.sum { |line| line[:words_count] })
  show_item[:bytes] = adjust_show_width(count_results.map.sum { |line| line[:bytes_count] })

  show_line = build_show_item(show_item, options)
  show_line << ' total'
  puts show_line
end

def adjust_show_width(sum_string)
  space = ' '
  sum_string.to_s.rjust(WIDTH_SUM_VALUES, space)
end

def build_show_item(show_item, options)
  show_line = ''
  if !options[:l] && !options[:w] && !options[:c]
    show_line << "#{show_item[:lines]}#{show_item[:words]}#{show_item[:bytes]}"
  else
    show_line << show_item[:lines].to_s if options[:l]
    show_line << show_item[:words].to_s if options[:w]
    show_line << show_item[:bytes].to_s if options[:c]
  end
  show_line
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
