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
    perm_oct.split('').map do |p_oct|
      p_bin = p_oct.to_i.to_s(2)
      convert_permission_bin_to_str(p_bin.rjust(3, '0'))
    end.join
  end

  def convert_permission_bin_to_str(perm_bin)
    [
      perm_bin[0].to_i.zero? ? '-' : 'r',
      perm_bin[1].to_i.zero? ? '-' : 'w',
      perm_bin[2].to_i.zero? ? '-' : 'x'
    ]
  end
end
