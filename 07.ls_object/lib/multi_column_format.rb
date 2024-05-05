# frozen_string_literal: true

class MultiColumnFormat
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def initialize(dir_entry_paths, base_path, max_col_size = MAX_COL_SIZE)
    @entry_names = collect_entry_names(dir_entry_paths, base_path)
    @max_col_size = max_col_size
  end

  def show()
    formated_lines = format_multi_column(@entry_names, @max_col_size)
    formated_lines.join("\n")
  end

  private

  def collect_entry_names(dir_entry_paths, base_path)
    dir_entry_paths.map { |path| File.file?(base_path) ? path : File.basename(path) }
  end

  def format_multi_column(show_items, col_size_max)
    col_size = [show_items.count, col_size_max].min
    row_size = show_items.count.ceildiv(col_size)
    width_per_col = calc_width_per_column(show_items, col_size)

    Array.new(row_size) do |i|
      Array.new(col_size) do |j|
        padding_space(show_items[i + row_size * j], width_per_col[j] + WIDTH_BETWEEN_ITMES)
      end.join.rstrip
    end
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
