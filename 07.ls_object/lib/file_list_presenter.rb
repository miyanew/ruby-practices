# frozen_string_literal: true

require_relative 'file_preparer'

class FileListPresenter
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def initialize(args)
    @opts = { path: args[:path], dot_match: args[:a], reverse: args[:r], long_format: args[:l] }
  end

  def show_file_list
    file_list = FilePreparer.new(@opts).prepare_file_list
    col_size = @opts[:long_format] ? 1 : MAX_COL_SIZE
    show_fixed_columns(file_list, col_size)
  end

  private

  def show_fixed_columns(show_items, col_size_max)
    show_line = ''
    col_size = show_items.count < col_size_max ? show_items.count : col_size_max
    row_size = show_items.count.ceildiv(col_size)
    width_per_col = calc_width_per_column(show_items, col_size)

    row_size.times do |i|
      tmp_line = []
      col_size.times do |j|
        tmp_line << padding_space(show_items[i + row_size * j], width_per_col[j] + WIDTH_BETWEEN_ITMES)
      end
      show_line += "#{tmp_line.join('').rstrip}\n"
    end

    show_line.chomp
  end

  def calc_width_per_column(items, col_size)
    width_per_column = {}
    row_size = items.size.ceildiv(col_size)

    col_size.times do |i|
      target = items[(row_size * i)..(row_size * (i + 1) - 1)]
      break if target.empty?

      width_per_column[i] = target.max_by(&:length).length
    end

    width_per_column
  end

  def padding_space(item, width)
    item&.ljust(width)
  end
end
