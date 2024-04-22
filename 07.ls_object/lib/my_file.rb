# frozen_string_literal: true

require 'etc'

class MyFile
  attr_reader :argpath, :basename, :blocks, :ftype, :permission_str, :nlink, :uname, :gname, :size, :mtime

  def initialize(target_path)
    @argpath = target_path
    @basename = File.basename(target_path)
    stat = File::Stat.new(target_path)
    @blocks = stat.blocks / 2 # デフォルトブロックサイズの差分を補正。File::Stat 512byte、Linux 1024byte
    @ftype = convert_ftype_to_1char(stat.ftype)
    @permission_oct = stat.mode.to_s(8)[-3..]
    @permission_str = convert_permission_oct_to_str(@permission_oct)
    @nlink = stat.nlink
    @uid = stat.uid
    @gid = stat.gid
    @uname = Etc.getpwuid(@uid).name
    @gname = Etc.getgrgid(@gid).name
    @size = stat.size
    @mtime = stat.mtime
  end

  private

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
