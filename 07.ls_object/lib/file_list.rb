# frozen_string_literal: true

require 'etc'

class FileList
  def initialize(opts)
    @opts = opts
    @files = collect_files(@opts[:path])
  end

  def prepare_file_list
    files = @opts[:reverse] ? @files.reverse : @files

    if @opts[:long_format] && File.directory?(@opts[:path])
      blocks_sum = files.sum { |f| f[:blocks] }
      ["total #{blocks_sum}", build_long_format(files)].flatten
    elsif @opts[:long_format]
      build_long_format(files)
    else
      build_name_list(files, @opts[:path])
    end
  end

  private

  def collect_files(target_path)
    flags = @opts[:dot_match] ? File::FNM_DOTMATCH : 0

    if File.directory?(target_path)
      Dir.glob(File.join(target_path, '*'), flags).map do |entry_name|
        collect_file(entry_name)
      end
    else
      [collect_file(target_path)]
    end
  end

  # blocks: デフォルトブロックサイズの差分を補正。File::Stat 512byte、Linux 1024byte
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

  def build_long_format(files)
    nlink_width = files.map { |file| file[:nlink] }.max.to_s.size

    files.map do |f|
      [
        f[:ftype] + f[:permission_str],
        f[:nlink].to_s.rjust(nlink_width),
        f[:uname],
        f[:gname],
        f[:size].to_s,
        f[:mtime].strftime('%b'),
        f[:mtime].strftime('%e').rjust(2),
        f[:mtime].strftime('%H:%M'),
        files.count > 1 ? f[:basename] : f[:argpath]
      ].join(' ')
    end
  end

  def build_name_list(files, target_path)
    File.directory?(target_path) ? files.map { |f| f[:basename] } : files.map { |f| f[:argpath] }
  end
end
