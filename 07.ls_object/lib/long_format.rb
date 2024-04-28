# frozen_string_literal: true

require_relative 'file_list'

class LongFormat
  def show(target_path:, dot_match: false, reverse: false)
    flist = FileList.new(target_path:, dot_match:)
    display_attrs = flist.list_long_format_attrs
    formatted_lines = format_long_format(display_attrs)
    sorted_lines = reverse ? formatted_lines.reverse : formatted_lines
    display_lines = File.directory?(target_path) ? ["total #{flist.total_blocksize}", sorted_lines].flatten : sorted_lines
    display_lines.join("\n")
  end

  private

  def format_long_format(attrs)
    nlink_width = attrs.map { |a| a[:nlink] }.max.to_s.size

    attrs.map do |a|
      file_mode          = a[:ftype] + a[:permission_str]
      num_nlink          = a[:nlink].to_s.rjust(nlink_width)
      owner_name         = a[:uname]
      group_name         = a[:gname]
      num_byte           = a[:size].to_s
      month              = a[:mtime].strftime('%b')
      day                = a[:mtime].strftime('%e').rjust(2)
      time_last_modified = a[:mtime].strftime('%H:%M')
      path               = attrs.count > 1 ? a[:basename] : a[:argpath]

      "#{file_mode} #{num_nlink} #{owner_name} #{group_name} #{num_byte} #{month} #{day} #{time_last_modified} #{path}"
    end
  end
end
