# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'

class TestLsCommand < Minitest::Test
  def test_ファイルパスを入力したらファイル名が表示される
    expected = <<~TEXT.chomp
      README.md  
    TEXT

    assert_equal expected, LsCommand.new.show('test/fixtures/README.md')
  end

  def test_フォルダパスを入力したら配下のファイル名とフォルダ名が表示される
    expected = <<~TEXT.chomp
      01.fizzbuzz  05.wc              99.wc_object  
      02.calendar  06.bowling_object  README.md  
      03.bowling   07.ls_object  
      04.ls        98.rake  
    TEXT

    assert_equal expected, LsCommand.new.show('test/fixtures')
  end
end
