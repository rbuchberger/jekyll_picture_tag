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

  # widths
  def test_widths
    @tested.expects(:check_widths).with([100, 150, 200])

    @tested.send(:widths)
  end

  # build_srcset_entry
  def test_build_srcset_entry
    file_stub = GeneratedImageStub.new(name: 'good filename')

    @tested.expects(:generate_file).with(200).returns(file_stub)
    PictureTag.expects(:build_url).with('good filename').returns('good url')

    assert_equal 'good url 2.0x', @tested.send(:build_srcset_entry, 200)
  end
end
