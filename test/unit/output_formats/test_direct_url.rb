require_relative './test_helper_output'

class TestDirectUrl < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::DirectUrl.new
  end

  def test_basic
    assert_equal 'good_url', @tested.to_s
  end
end
