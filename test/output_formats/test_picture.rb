require 'test_helper'

class TestOutputFormatPicture < Minitest::Test
  include PictureTag
  include TestHelper
  def setup
    @tested = OutputFormats::Picture.new
  end

  # srcsets
  def test_srcset
    skip
    PictureTag.expects(:formats).returns(%w[first second])
    PictureTag.expects(:source_images)
              .returns('media1' => 'image1', 'media2' => 'image2')

    assert_equal []
  end
  # build_sources
  # build_source
  # base_markup
end
