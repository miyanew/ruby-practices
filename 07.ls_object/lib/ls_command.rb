# frozen_string_literal: true

require_relative 'file_collecter'
require_relative 'file_list_presenter'

class LsCommand
  def initialize(options)
    @options = options
    @files = collect_files(options)
  end

  def show
    if @options[:r]
      FileListPresenter.new.show_items(@files.map(&:basename).reverse)
    else
      FileListPresenter.new.show_items(@files.map(&:basename))
    end
  end

  private

  def collect_files(options)
    FileCollecter.new(options[:path]).files
  end
end
