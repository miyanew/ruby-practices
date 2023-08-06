#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'

WIDTH_SUM_VALUES = 8

def main(args)
  options = {}
  options[:filepaths] = args[:filepaths] ||= false
  options[:l]         = args[:l] ||= false
  options[:w]         = args[:w] ||= false
  options[:c]         = args[:c] ||= false

  input_lines = []
  # count_result = []
  # input_lines = collect_input(options[:filepaths])
  # collect_input(filepaths)

  if is_file_specified(options[:filepaths])
    options[:filepaths].each do |fp|
      input_file = {}
      input_file[:filepath] = fp
      input_file[:body] = File.open(fp){|f| f.readlines.map(&:chomp)}
      input_lines << input_file
    end
  else
    stdin = {}
    stdin[:filepath] = nil
    stdin[:body] = readlines.map(&:chomp)
    input_lines << stdin
  end

  # puts input_lines[0][:body].class #Array、もしreadlinesでto_sすると -> Sting
  
  input_lines.each do |line|
    count_input_lines(line)
  end

  show_result(input_lines)
end

def is_file_specified(input_lines)
  !input_lines.size.zero?
end

def count_input_lines(line_params)
    rets = []
    line_params[:body].to_a.map do |row|
      ret = {}
      ret[:lines_count] = 1
      ret[:words_count] = count_devide_by_space(row)
      ret[:bytes_count] = count_bytesize_with_linefeed(row)
      rets << ret
    end

    line_params[:lines_count] = rets.map {|ret| ret[:lines_count]}.sum
    line_params[:words_count] = rets.map {|ret| ret[:words_count]}.sum
    line_params[:bytes_count] = rets.map {|ret| ret[:bytes_count]}.sum
    line_params
end

def count_devide_by_space(input_line)
  input_line.split("\s").size
end

# zshの標準出力と揃えるため、末尾に改行コードを付与する
def count_bytesize_with_linefeed(input_line)
  input_line.bytesize + "\n".bytesize
end

def show_result(input_lines)
  if input_lines[0][:filepath].nil?
    space = ' '
    lines_sum = input_lines[0][:lines_count].to_s.rjust(WIDTH_SUM_VALUES, space)
    words_sum = input_lines[0][:words_count].to_s.rjust(WIDTH_SUM_VALUES, space)
    bytes_sum = input_lines[0][:bytes_count].to_s.rjust(WIDTH_SUM_VALUES, space)

    show_line = ''
    show_line << lines_sum
    show_line << words_sum
    show_line << bytes_sum
    puts show_line
  end

  #words_sum = input_lines.map {|ret| ret[:words_count]}.to_s.rjust(WIDTH_SUM_VALUES, space)
  #bytes_sum = input_lines.map {|ret| ret[:bytes_count]}.to_s.rjust(WIDTH_SUM_VALUES, space)


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
