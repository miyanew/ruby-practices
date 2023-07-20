#!/usr/bin/env ruby
# frozen_string_literal: false

# lsコマンド
#   Done: ph1 オプション無で作る ファイル名を表示、昇順
#   Todo: ph2 -aオプションを作る 隠しファイルを表示
#   Todo: ph3 -rオプションを作る 逆順(ファイル名)で表示
#   Todo: ph4 -lオプションを作る 各種情報を表示 & ファイルの合計ブロックサイズ
#   Todo: ph5 これまでの全ての機能をもったlsを作る
MAX_COL_SIZE = 3
WIDTH_BETWEEN_ITMES = 7

def main(options)
  options[:path] = Dir.pwd if options[:path].nil?

  Dir.chdir(options[:path])
  filenames = Dir.glob('*', sort: true)
  show_filenames(filenames)
end

def show_filenames(filenames)
  return if filenames.empty?

  margined_filenames = add_margin_right_of_items(filenames)
  max_row_size = margined_filenames.size.ceildiv(MAX_COL_SIZE)
  max_row_size.times do |i|
    show_line = []
    MAX_COL_SIZE.times do |j|
      show_line << margined_filenames[i + max_row_size * j] unless margined_filenames[i + max_row_size * j].nil?
      puts show_line.join('') if j == MAX_COL_SIZE - 1
    end
  end
end

def add_margin_right_of_items(filenames)
  width_per_item = filenames.max_by(&:length).length + WIDTH_BETWEEN_ITMES
  filenames.map { |file_name| file_name.ljust(width_per_item) }
end

if $PROGRAM_NAME == __FILE__
  require 'optparse'
  opt = OptionParser.new

  params = {}
  opt.parse!(ARGV)
  params[:path] = ARGV[0]

  main(params)
end
