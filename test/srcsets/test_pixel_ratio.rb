require 'test_helper'
class TestSrcsetPixelRatio < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @source_image = SourceImageStub.new(width: 1000, shortname: 'some name')

    PictureTag.stubs(:source_images).returns(
      'mobile' => @source_image
    )

    PictureTag.stubs(:preset).returns('pixel_ratios' => [1, 1.5, 2],
                                      'base_width' => 100)

    @tested = Srcsets::PixelRatio.new(
      media: 'mobile',
      format: 'some format'
    )
  end
end
