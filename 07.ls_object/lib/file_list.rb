# frozen_string_literal: true

require 'etc'

class FileList
  LONG_FORMAT_ATTRS = %i[argpath basename blocks ftype permission_str nlink uname gname size mtime].freeze

  def initialize(target_path:, dot_match: false)
    @files = collect_files(target_path, dot_match)
  end

  def list_file_dir_entry
    key_path = File.directory?(@files[0][:argpath]) ? :basename : :argpath
    @files.map { |f| f[key_path] }
  end

  def list_long_format_attrs
    @files.map { |f| LONG_FORMAT_ATTRS.each_with_object({}) { |attr, display_attrs| display_attrs[attr] = f[attr] } }
  end

  def total_blocksize
    @files.sum { |f| f[:blocks] }
  end

  private

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
