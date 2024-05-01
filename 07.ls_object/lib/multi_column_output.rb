# frozen_string_literal: true

require 'etc'

class MultiColumnOutput
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def show(target_path:, dot_match: false, reverse: false)
    @files = collect_files(target_path, dot_match)
    entry_names = list_file_dir_entry(@files)
    sorted_entry_names = reverse ? entry_names.reverse : entry_names
    format_multi_column(sorted_entry_names, MAX_COL_SIZE)
  end

  private

  def list_file_dir_entry(files)
    key_path = File.directory?(files[0][:argpath]) ? :basename : :argpath
    files.map { |f| f[key_path] }
  end

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

  def collect_files(target_path, dot_match)
    flags = dot_match ? File::FNM_DOTMATCH : 0

    if File.directory?(target_path)
      Dir.glob(File.join(target_path, '*'), flags).map do |entry_name|
        collect_file(entry_name)
      end
    else
      [collect_file(target_path)]
    end
  end

  # blocks: デフォルトブロックサイズ差分を/2で補正。File::Stat 512byte、Linux 1024byte
  def collect_file(target_path)
    stat = File::Stat.new(target_path)
    {
      argpath: target_path,
      basename: File.basename(target_path),
      blocks: stat.blocks / 2,
      ftype: convert_ftype_to_1char(stat.ftype),
      permission_oct: stat.mode.to_s(8)[-3..],
      permission_str: convert_permission_oct_to_str(stat.mode.to_s(8)[-3..]),
      nlink: stat.nlink,
      uid: stat.uid,
      gid: stat.gid,
      uname: Etc.getpwuid(stat.uid).name,
      gname: Etc.getgrgid(stat.gid).name,
      size: stat.size,
      mtime: stat.mtime
    }
  end

  def convert_ftype_to_1char(ftype)
    ftype == 'file' ? '-' : ftype[0]
  end

  def convert_permission_oct_to_str(perm_oct)
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

    perm_oct.chars.map { |p_oct| permissions[p_oct] }.join
  end

end
