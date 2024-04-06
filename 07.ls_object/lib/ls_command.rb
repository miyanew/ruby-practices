# frozen_string_literal: true

class LsCommand
  def show(target_path)
    FileListPresenter.new.show(target_path)
  end
end

class FileListPresenter
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 7

  def show(target_path)
    files = collect_filenames(target_path)
    show_filenames(files)
  end

  private

  def collect_filenames(target_path)
    if File.directory?(target_path)
      Dir.chdir(target_path)
      Dir.glob('*', flags)
    else
      Dir.chdir(File.dirname(File.expand_path(target_path)))
      [File.basename(target_path)]
    end
  end

  def show_filenames(filenames)
    margined_filenames = add_margin_right_of_items(filenames)
    max_row_size = margined_filenames.size.ceildiv(MAX_COL_SIZE)
    result = ''
    max_row_size.times do |i|
      show_line = []
      MAX_COL_SIZE.times do |j|
        show_line << margined_filenames[i + max_row_size * j] unless margined_filenames[i + max_row_size * j].nil?
      end
      result += "#{show_line.join('')}\n"
    end
    result.rstrip.chomp
  end

  def add_margin_right_of_items(filenames)
    width_per_item = filenames.max_by(&:length).length + WIDTH_BETWEEN_ITMES
    filenames.map { |file_name| file_name.ljust(width_per_item) }
  end
end
