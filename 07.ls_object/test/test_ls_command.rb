# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'

class TestLsCommand < Minitest::Test
  def test_ファイルパスを入力したらファイル名が表示される
    expected = <<~TEXT.chomp
      README.md
    TEXT

    ls = LsCommand.new
    assert_equal expected, ls.show('test/fixtures/README.md')
  end
end
