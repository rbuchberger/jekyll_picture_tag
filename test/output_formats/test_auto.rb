require 'test_helper'

class TestOutputFormatAuto < Minitest::Test
  include PictureTag
  include TestHelper

  # one srcset
  def test_one_srcset
    Utils.stubs(:count_srcsets).returns 1

    OutputFormats::Img.expects(:new)

    OutputFormats::Auto.new
  end
  # multiple srcsets

  def test_multiple_srcsets
    Utils.stubs(:count_srcsets).returns 3

    OutputFormats::Picture.expects(:new)

    OutputFormats::Auto.new
  end
end
