# frozen_string_literal: true

require 'etc'

class LongFormat
  def initialize(dir_entry_paths)
    @dir_entry_paths = dir_entry_paths
  end

  def show(reverse)
    sorted_entry_paths = reverse ? @dir_entry_paths.reverse : @dir_entry_paths
    formatted_lines = format_long_format(sorted_entry_paths)
    formatted_lines = prepend_total_blocks(formatted_lines) if File.directory?(@dir_entry_paths[0])
    formatted_lines.join("\n")
  end

  private

  def format_long_format(entry_paths)
    nlink_width = entry_paths.map { |path| File::Stat.new(path).nlink }.max.to_s.size

    entry_paths.map do |path|
      stat = File::Stat.new(path)

      file_mode          = get_file_mode(stat)
      num_nlink          = stat.nlink.to_s.rjust(nlink_width)
      owner_name         = Etc.getpwuid(stat.uid).name
      group_name         = Etc.getgrgid(stat.gid).name
      num_byte           = stat.size
      month              = stat.mtime.strftime('%b')
      day                = stat.mtime.strftime('%e').rjust(2)
      time_last_modified = stat.mtime.strftime('%H:%M')
      pathname           = entry_paths.count > 1 ? File.basename(path) : path

      "#{file_mode} #{num_nlink} #{owner_name} #{group_name} #{num_byte} #{month} #{day} #{time_last_modified} #{pathname}"
    end
  end

  def get_file_mode(stat)
    head_char = stat.ftype == 'file' ? '-' : stat.ftype[0]

    permissions = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }
    permission_oct = stat.mode.to_s(8)[-3..]
    permission_str = permission_oct.chars.map { |p_oct| permissions[p_oct] }.join

    "#{head_char}#{permission_str}"
  end

  def prepend_total_blocks(formatted_lines)
    ["total #{total_blocks}", formatted_lines].flatten
  end

  # blocks: デフォルトブロックサイズ差分を/2で補正。File::Stat 512byte、Linux 1024byte
  def total_blocks
    @dir_entry_paths.sum { |path| File::Stat.new(path).blocks / 2 }
  end
end
