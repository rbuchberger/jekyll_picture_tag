require_relative './test_helper_output'

class TestNakedSrcset < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::NakedSrcset.new
  end

  def test_basic
    assert_equal 'ss', @tested.to_s
  end
end
