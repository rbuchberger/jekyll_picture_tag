require 'test_helper'

class TestOutputFormatImg < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @tested = OutputFormats::Img.new
  end

  # srcset
  def test_srcset
    PictureTag.expects(:formats).returns(['some format'])
    @tested.expects(:build_srcset).with(nil, 'some format')
    @tested.srcset
  end

  # base_markup
  def test_base_markup
    dummy_img = Object.new
    dummy_srcset = Object.new
    dummy_attributes = Object.new

    @tested.expects(:build_base_img).returns(dummy_img)
    @tested.stubs(:srcset).returns(dummy_srcset)
    @tested.expects(:add_srcset).with(dummy_img, dummy_srcset)
    @tested.expects(:add_sizes).with(dummy_img, dummy_srcset)

    dummy_img.expects(:attributes).returns(dummy_attributes)
    dummy_attributes.expects(:<<).with('attributes')
    PictureTag.stubs(:html_attributes).returns('parent' => 'attributes')

    @tested.base_markup
  end
end
