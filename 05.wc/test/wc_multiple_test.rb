# frozen_string_literal: true

require 'minitest/autorun'

class WcMultipleTest < Minitest::Test
  def test_output_when_no_options_are_specified
    output = `./wc.rb ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       3       9      45 ./test/fixtures/file1.txt
       3       7      46 ./test/fixtures/file2.txt
       6      16      91 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_l_is_specified
    output = `./wc.rb -l ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       3 ./test/fixtures/file1.txt
       3 ./test/fixtures/file2.txt
       6 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_w_is_specified
    output = `./wc.rb -w ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       9 ./test/fixtures/file1.txt
       7 ./test/fixtures/file2.txt
      16 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_c_is_specified
    output = `./wc.rb -c ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
      45 ./test/fixtures/file1.txt
      46 ./test/fixtures/file2.txt
      91 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_lw_are_specified
    output = `./wc.rb -lw ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       3       9 ./test/fixtures/file1.txt
       3       7 ./test/fixtures/file2.txt
       6      16 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_wc_are_specified
    output = `./wc.rb -wc ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       9      45 ./test/fixtures/file1.txt
       7      46 ./test/fixtures/file2.txt
      16      91 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_lc_are_specified
    output = `./wc.rb -lc ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       3      45 ./test/fixtures/file1.txt
       3      46 ./test/fixtures/file2.txt
       6      91 total
    TEXT
    assert_equal output, expected
  end

  def test_output_when_lwc_are_specified
    output = `./wc.rb -lwc ./test/fixtures/file1.txt ./test/fixtures/file2.txt`
    expected = <<-TEXT
       3       9      45 ./test/fixtures/file1.txt
       3       7      46 ./test/fixtures/file2.txt
       6      16      91 total
    TEXT
    assert_equal output, expected
  end
end
