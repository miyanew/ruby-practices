#!/usr/bin/env ruby
# frozen_string_literal: false

# lsコマンド
#   Done: ph1 オプション無で作る ファイル名を表示、昇順
#   Todo: ph2 -aオプションを作る 隠しファイルを表示
#   Todo: ph3 -rオプションを作る 逆順(ファイル名)で表示
#   Todo: ph4 -lオプションを作る 各種情報を表示 & ファイルの合計ブロックサイズ
#   Todo: ph5 これまでの全ての機能をもったlsを作る
module Ls
  class Ls::Command
    MAX_COL_SIZE = 3
    WIDTH_BETWEEN_ITMES = 7

    def initialize(options)
      @options = options
      @options[:path] = Dir.pwd if options[:path].nil?
    end

    def execute
      @filenames = retrieve_filenames
      hide_hidden_filenames
      sort_filenames
      show_filenames
    end

    def retrieve_filenames
      Dir.children(@options[:path])
    end

    def hide_hidden_filenames
      @filenames = @filenames.reject { |str| str.start_with?(/\A\./) }
    end

    def sort_filenames
      @filenames = @filenames.sort
    end

    def show_filenames
      return if @filenames.empty?

      add_margin_right_of_items
      show_line = []
      max_row_size = calcutate_max_row_size(@filenames.size, MAX_COL_SIZE)
      max_row_size.times do |i|
        MAX_COL_SIZE.times do |j|
          show_line << @filenames[i + max_row_size * j] unless @filenames[i + max_row_size * j].nil?
        end
        puts show_line.join('')
        show_line.clear
      end
    end

    def add_margin_right_of_items
      width_per_item = @filenames.max_by(&:length).length + WIDTH_BETWEEN_ITMES
      @filenames = @filenames.map { |file_name| file_name.ljust(width_per_item) }
    end

    def calcutate_max_row_size(sum_of_items, separate_pos)
      row_size = sum_of_items / separate_pos
      return row_size if (sum_of_items % separate_pos).zero?

      row_size + 1
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'optparse'
  opt = OptionParser.new

  params = {}
  opt.parse!(ARGV)
  params[:path] = ARGV[0]

  ls_command = Ls::Command.new(**params)
  ls_command.execute
end
