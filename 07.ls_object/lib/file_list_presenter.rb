# frozen_string_literal: true

require_relative 'file_list'

class FileListPresenter
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def initialize(args)
    @opts = { path: args[:path], dot_match: args[:a], reverse: args[:r], long_format: args[:l] }
  end

  def show_file_list
    if @opts[:long_format]
      fl = FileList.new(target_path: @opts[:path], dot_match: @opts[:dot_match])
      file_list = fl.list_long_format_props
      file_list = format_long_format_props(file_list)
      file_list = @opts[:reverse] ? file_list.reverse : file_list
      file_list = ["total #{fl.total_blocksize}", file_list].flatten if File.directory?(@opts[:path])
    elsif
      file_list = FileList.new(target_path: @opts[:path], dot_match: @opts[:dot_match]).list_file_dir_entry
      file_list = @opts[:reverse] ? file_list.reverse : file_list
    end

    if @opts[:long_format] || file_list.count == 1
      show_single_column(file_list)
    else
      show_multi_column(file_list, MAX_COL_SIZE)
    end
  end

  private

  def format_long_format_props(files)
    nlink_width = files.map { |f| f[:nlink] }.max.to_s.size

    f_list = files.map do |f|
      {
        permission: f[:ftype] + f[:permission_str],
        nlink: f[:nlink].to_s.rjust(nlink_width),
        uname: f[:uname],
        gname: f[:gname],
        size: f[:size].to_s,
        month: f[:mtime].strftime('%b'),
        day: f[:mtime].strftime('%e').rjust(2),
        time: f[:mtime].strftime('%H:%M'),
        path: files.count > 1 ? f[:basename] : f[:argpath]
      }
    end

    f_list.map do |info|
      "#{info[:permission]} #{info[:nlink]} #{info[:uname]} #{info[:gname]} #{info[:size]} #{info[:month]} #{info[:day]} #{info[:time]} #{info[:path]}"
    end
  end

  def show_single_column(show_items)
    show_items.join("\n")
  end

  def show_multi_column(show_items, col_size_max)
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
