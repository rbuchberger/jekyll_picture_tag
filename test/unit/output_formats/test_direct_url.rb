require_relative 'output_format_test_helper'

class TestDirectUrl < Minitest::Test
  include OutputFormatTestHelper

  def tested
    @tested ||= OutputFormats::DirectUrl.new
  end

  def test_basic
    assert_equal 'good_url', tested.to_s
  end
end
