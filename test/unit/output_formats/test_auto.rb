require 'test_helper'

class TestAuto < Minitest::Test
  include PictureTag
  include TestHelper

  # one srcset
  def test_one_srcset
    Utils.stubs(count_srcsets: 1)

    OutputFormats::Img.expects(:new)

    OutputFormats::Auto.new
  end
  # multiple srcsets

  def test_multiple_srcsets
    Utils.stubs(count_srcsets: 3)

    OutputFormats::Picture.expects(:new)

    OutputFormats::Auto.new
  end
end
