# frozen_string_literal: true

require 'minitest/autorun'

class WcStdinTest < Minitest::Test
  def test_output_when_no_options_are_specified
    output = `../04.ls/ls.rb -l | ./wc.rb`
    expected = "       4      29     170\n"
    assert_equal output, expected
  end

  def test_output_when_l_is_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -l`
    expected = "       4\n"
    assert_equal output, expected
  end

  def test_output_when_w_is_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -w`
    expected = "      29\n"
    assert_equal output, expected
  end

  def test_output_when_c_is_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -c`
    expected = "     170\n"
    assert_equal output, expected
  end

  def test_output_when_lw_are_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -lw`
    expected = "       4      29\n"
    assert_equal output, expected
  end

  def test_output_when_wc_are_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -wc`
    expected = "      29     170\n"
    assert_equal output, expected
  end

  def test_output_when_lc_are_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -lc`
    expected = "       4     170\n"
    assert_equal output, expected
  end

  def test_output_when_lwc_are_specified
    output = `../04.ls/ls.rb -l | ./wc.rb -lwc`
    expected = "       4      29     170\n"
    assert_equal output, expected
  end
end
