require_relative 'output_format_test_helper'

class TestNakedSrcset < Minitest::Test
  include OutputFormatTestHelper

  def tested
    @tested ||= OutputFormats::NakedSrcset.new
  end

  def test_basic
    assert_equal 'ss', tested.to_s
  end
end
