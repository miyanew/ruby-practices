# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_list_presenter'

class TestLsCommand < Minitest::Test
  def test_ファイル名が表示される
    expected = <<~TEXT.chomp
      test/fixtures/README.md
    TEXT

    args = {}
    args[:path] = 'test/fixtures/README.md'
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_入力したフォルダ配下のファイル名とフォルダ名が表示される
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

  def test_入力したフォルダ配下のファイル名とフォルダ名が逆順で表示される
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

  def test_ドットファイルを含めて表示される
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

  def test_ドットファイルを含めて逆順で表示される
    expected = <<~TEXT.chomp
      README.md     06.bowling_object  02.calendar
      99.wc_object  05.wc              01.fizzbuzz
      98.rake       04.ls              .
      07.ls_object  03.bowling
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    args[:r] = true
    args[:a] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_プロパティを含めてファイル名が表示される
    expected = <<~TEXT.chomp
      -rw-r--r-- 1 deb deb 2648 Mar  1 00:01 test/fixtures/README.md
    TEXT

    args = {}
    args[:path] = 'test/fixtures/README.md'
    args[:l] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_入力したフォルダ配下のファイル名とフォルダ名がプロパティ含めて表示される
    expected = <<~TEXT.chomp
      total 40
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 01.fizzbuzz
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 02.calendar
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 03.bowling
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 04.ls
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 05.wc
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 06.bowling_object
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 07.ls_object
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 98.rake
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 99.wc_object
      -rw-r--r-- 1 deb deb 2648 Mar  1 00:01 README.md
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    args[:l] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end

  def test_入力したフォルダ配下のファイル名とフォルダ名がプロパティ含めて逆順で表示される
    expected = <<~TEXT.chomp
      total 40
      -rw-r--r-- 1 deb deb 2648 Mar  1 00:01 README.md
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 99.wc_object
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 98.rake
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 07.ls_object
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 06.bowling_object
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 05.wc
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 04.ls
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 03.bowling
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 02.calendar
      drwxr-xr-x 2 deb deb 4096 Apr 14 13:01 01.fizzbuzz
    TEXT

    args = {}
    args[:path] = 'test/fixtures'
    args[:r] = true
    args[:l] = true
    assert_equal expected, FileListPresenter.new(args).show_file_list
  end
end
