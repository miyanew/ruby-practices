# frozen_string_literal: true

class FileCollecter
  attr_reader :files

  def initialize(target_path)
    @files = collect_files(target_path)
  end

  private

  def collect_files(target_path)
    files = []
    if File.directory?(target_path)
      Dir.glob(File.join(target_path, '*')).each do |file_path|
        files << MyFile.new(File.expand_path(file_path))
      end
    else
      files << MyFile.new(File.expand_path(target_path))
    end
    files
  end
end

class MyFile
  attr_reader :basename

  def initialize(fullpath)
    @basename = File.basename(fullpath)
    stat = File::Stat.new(fullpath)
    @blocks = stat.blocks
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
    perm_str = ''
    perm_str += (perm_bin[0].to_i.zero? ? '-' : 'r')
    perm_str += (perm_bin[1].to_i.zero? ? '-' : 'w')
    perm_str + (perm_bin[2].to_i.zero? ? '-' : 'x')
  end
end
