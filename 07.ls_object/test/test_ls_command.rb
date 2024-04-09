# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_list_presenter'

class TestLsCommand < Minitest::Test
  def test_ファイルパスを入力したらファイル名が表示される
    expected = <<~TEXT.chomp
      test/fixtures/README.md
    TEXT

    args = {}
    args[:path] = 'test/fixtures/README.md'
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_フォルダパスを入力したら配下のファイル名とフォルダ名が表示される
    expected = <<~TEXT.chomp
      01.fizzbuzz  05.wc              99.wc_object
      02.calendar  06.bowling_object  README.md
      03.bowling   07.ls_object
      04.ls        98.rake
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_ファイル名とフォルダ名が逆順で表示される
    expected = <<~TEXT.chomp
      README.md     06.bowling_object  02.calendar
      99.wc_object  05.wc              01.fizzbuzz
      98.rake       04.ls
      07.ls_object  03.bowling
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    args[:r] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_ドットファイルも含めて表示される
    expected = <<~TEXT.chomp
      .            04.ls              98.rake
      01.fizzbuzz  05.wc              99.wc_object
      02.calendar  06.bowling_object  README.md
      03.bowling   07.ls_object
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    args[:a] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_ファイルパスを入力したらプロパティを含めて表示される
    expected = <<~TEXT.chomp
      -rw-r--r-- 1 deb deb 2648 Apr  6 22:32 test/fixtures/README.md
    TEXT

    args = {}
    args[:path] = 'test/fixtures/README.md'
    args[:l] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end
end
