# frozen_string_literal: true

class FileListPresenter
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def show_items(items)
    show_fixed_columns(items, MAX_COL_SIZE)
  end

  private

  def show_fixed_columns(items, col_size)
    show_line = ''
    row_size = items.size.ceildiv(col_size)
    col_size = items.size if items.size < col_size
    width_per_col = calc_width_per_column(items, col_size)

    row_size.times do |i|
      tmp_line = []
      col_size.times do |j|
        tmp_line << padding_space(items[i + row_size * j], width_per_col[j] + WIDTH_BETWEEN_ITMES)
      end
      show_line += "#{tmp_line.join('').rstrip}\n"
    end

    show_line.chomp
  end

  def padding_space(item, width)
    item&.ljust(width)
  end

  def calc_width_per_column(items, col_size)
    width_per_column = {}
    row_size = items.size.ceildiv(col_size)

    col_size.times do |i|
      target = items[(row_size * i)..(row_size * (i + 1) - 1)]
      break if target.empty?

      width_per_column[i] = target.max_by(&:size).size
    end

    width_per_column
  end
end
