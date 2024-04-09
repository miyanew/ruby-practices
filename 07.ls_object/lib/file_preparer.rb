# frozen_string_literal: true

require_relative 'my_file'

class FilePreparer
  def initialize(opts)
    @opts = opts
    @files = collect_files(@opts[:path])
  end

  def prepare_file_list
    files = @opts[:reverse] ? @files.reverse : @files

    if @opts[:long_format] && File.directory?(@opts[:path])
      blocks_sum = files.sum(&:blocks)
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
        MyFile.new(entry_name)
      end
    else
      [MyFile.new(target_path)]
    end
  end

  def build_long_format(files)
    files.map do |f|
      [
        f.ftype + f.permission_str,
        f.nlink.to_s,
        f.uname.to_s,
        f.gname.to_s,
        f.size.to_s,
        f.mtime.strftime('%b'),
        f.mtime.strftime('%e %H:%M'),
        files.count > 1 ? f.basename : f.argpath
      ].join(' ')
    end
  end

  def build_name_list(files, target_path)
    File.directory?(target_path) ? files.map(&:basename) : files.map(&:argpath)
  end
end
