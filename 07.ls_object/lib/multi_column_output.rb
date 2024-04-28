# frozen_string_literal: true

require_relative 'file_list'

class MultiColumnOutput
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def show(target_path:, dot_match: false, reverse: false)
    flist = FileList.new(target_path:, dot_match:)
    entry_names = flist.list_file_dir_entry
    sorted_entry_names = reverse ? entry_names.reverse : entry_names
    format_multi_column(sorted_entry_names, MAX_COL_SIZE)
  end

  private

  def format_multi_column(show_items, col_size_max)
    col_size = [show_items.count, col_size_max].min
    row_size = show_items.count.ceildiv(col_size)
    width_per_col = calc_width_per_column(show_items, col_size)

    Array.new(row_size) do |i|
      Array.new(col_size) do |j|
        padding_space(show_items[i + row_size * j], width_per_col[j] + WIDTH_BETWEEN_ITMES)
      end.join.rstrip
    end.join("\n")
  end

  def calc_width_per_column(items, col_size)
    row_size = items.size.ceildiv(col_size)

    Array.new(col_size) do |i|
      target = items[(row_size * i)..(row_size * (i + 1) - 1)]
      break if target.empty?

      target.max_by(&:length).length
    end
  end

  def padding_space(item, width)
    item&.ljust(width)
  end
end
