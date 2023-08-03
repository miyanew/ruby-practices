#!/usr/bin/env ruby
# frozen_string_literal: false

require 'optparse'
require 'etc'

# lsコマンド
#   Done: ph1 オプション無で作る ファイル名を表示、昇順
#   Done: ph2 -aオプションを作る 隠しファイルを表示
#   Done: ph3 -rオプションを作る 逆順(ファイル名)で表示
#   Done: ph4 -lオプションを作る 各種情報を表示 & ファイルの合計ブロックサイズ
#   Todo: ph5 これまでの全ての機能をもったlsを作る
MAX_COL_SIZE = 3
WIDTH_BETWEEN_ITMES = 7

def main(options)
  options[:path] = options[:path] ||= Dir.pwd
  options[:a]    = options[:a] ||= false
  options[:r]    = options[:r] ||= false
  options[:l]    = options[:l] ||= false

  unless File.exist?(options[:path])
    puts "ls: #{options[:path]}: No such file or directory"
    exit
  end

  filenames = collect_filenames(options[:path])
  filenames = filenames.reverse if options[:r]

  if options[:l]
    parentpath = File.directory?(options[:path]) ? options[:path] : File.dirname(options[:path])
    fullpaths = filenames.map { |fn| File.join(parentpath, fn) }
    file_metadatas = collect_file_metadatas(fullpaths)
    show_file_metadatas(file_metadatas, File.directory?(options[:path]))
  else
    show_filenames(filenames)
  end
end

def collect_filenames(path)
  if File.directory?(path)
    Dir.chdir(path)
    Dir.glob('*')
  else
    Dir.chdir(File.dirname(path))
    [File.basename(path)]
  end
end

def collect_file_metadatas(fullpaths)
  metadatas = []
  fullpaths.each do |fp|
    stat = File::Stat.new(fp)
    metadatas << {}
    metadata = metadatas.last
    metadata[:fullpath] = fp
    metadata[:basename] = File.basename(fp)
    metadata[:blocks] = stat.blocks
    metadata[:ftype] = convert_ftype_to_1char(stat.ftype)
    metadata[:permission_oct] = stat.mode.to_s(8)[-3..]
    metadata[:permission_str] = convert_permission_oct_to_str(metadata[:permission_oct])
    metadata[:nlink] = stat.nlink
    metadata[:uid] = stat.uid
    metadata[:gid] = stat.gid
    metadata[:uname] = Etc.getpwuid(metadata[:uid]).name
    metadata[:gname] = Etc.getgrgid(metadata[:gid]).name
    metadata[:size] = stat.size
    metadata[:mtime] = stat.mtime
  end
  metadatas
end

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
  perm_str << (perm_bin[0].to_i.zero? ? '-' : 'r')
  perm_str << (perm_bin[1].to_i.zero? ? '-' : 'w')
  perm_str << (perm_bin[2].to_i.zero? ? '-' : 'x')
end

def show_file_metadatas(file_metadatas, parampath_is_directory)
  puts "total #{file_metadatas.select.map.sum { |md| md[:blocks] }}" if parampath_is_directory
  file_metadatas.each do |md|
    puts show_metadata(md, file_metadatas)
  end
end

def show_metadata(metadata, metadatas)
  space = ' '
  show_line = ''
  show_line << metadata[:ftype]
  show_line << metadata[:permission_str]
  show_line << space * 2
  show_line << metadata[:nlink].to_s.rjust(calc_max_width(metadatas, :nlink), space)
  show_line << space
  show_line << metadata[:uname].to_s.ljust(calc_max_width(metadatas, :uname), space)
  show_line << space * 2
  show_line << metadata[:gname].to_s.ljust(calc_max_width(metadatas, :gname), space)
  show_line << space * 2
  show_line << metadata[:size].to_s.rjust(calc_max_width(metadatas, :size), space)
  show_line << space * 2
  show_line << metadata[:mtime].strftime('%m').to_i.to_s
  show_line << space
  show_line << metadata[:mtime].strftime('%e %H:%M')
  show_line << space
  show_line << metadata[:basename]
end

def calc_max_width(metadatas, key_metadata)
  metadatas.select.map { |m| m[key_metadata].to_s.length }.max
end

def show_filenames(filenames)
  return if filenames.empty?

  margined_filenames = add_margin_right_of_items(filenames)
  max_row_size = margined_filenames.size.ceildiv(MAX_COL_SIZE)
  max_row_size.times do |i|
    show_line = []
    MAX_COL_SIZE.times do |j|
      show_line << margined_filenames[i + max_row_size * j] unless margined_filenames[i + max_row_size * j].nil?
    end
    puts show_line.join('')
  end
end

def add_margin_right_of_items(filenames)
  width_per_item = filenames.max_by(&:length).length + WIDTH_BETWEEN_ITMES
  filenames.map { |file_name| file_name.ljust(width_per_item) }
end

if $PROGRAM_NAME == __FILE__
  opt = OptionParser.new

  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)
  params[:path] = ARGV[0]

  main(params)
end
