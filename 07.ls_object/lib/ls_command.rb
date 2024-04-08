# frozen_string_literal: true

require_relative 'file_collecter'
require_relative 'file_list_presenter'

class LsCommand
  def initialize(options)
    @options = options
    @files = collect_files(options)
  end

  def show
    files = @files.map(&:basename)
    files = files.reject { |file| file =~ /^\.{1,2}$/ } unless @options[:a]
    files = files.reverse if @options[:r]
    FileListPresenter.new.show_items(files)
  end

  private

  def collect_files(options)
    FileCollecter.new(options[:path]).files
  end
end
