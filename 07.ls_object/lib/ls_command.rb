# frozen_string_literal: true

class LsCommand
  def show(target_path)
    FileListPresenter.new.show(target_path)
  end
end

class FileListPresenter
  MAX_COL_SIZE = 3
  WIDTH_BETWEEN_ITMES = 2

  def show(target_path)
    files = collect_filenames(target_path)
    show_filenames(files)
  end

  private

  def collect_filenames(target_path)
    if File.directory?(target_path)
      Dir.glob(File.join(target_path, '*')).map { |fn| File.basename(fn) }
    else
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
      result += "#{show_line.join('').rstrip}" + ' ' * WIDTH_BETWEEN_ITMES + "\n"
    end
    result.chomp
  end

  def add_margin_right_of_items(filenames)
    tmp = []
    max_row = filenames.size.ceildiv(MAX_COL_SIZE)
    MAX_COL_SIZE.times do |i|
        target = filenames[(max_row * i)..(max_row * (i + 1) - 1)]
        break if target.empty?

        max_length = target.max_by(&:size).size
        tmp << target.map { |file_name| file_name.ljust(max_length + WIDTH_BETWEEN_ITMES) }
    end
    tmp.flatten
  end
end
