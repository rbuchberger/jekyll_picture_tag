require 'test_helper'

class TestDataAuto < Minitest::Test
  include PictureTag
  include TestHelper

  # one srcset
  def test_one_srcset
    Utils.stubs(count_srcsets: 1)

    OutputFormats::DataImg.expects(:new)

    OutputFormats::DataAuto.new
  end
  # multiple srcsets

  def test_multiple_srcsets
    Utils.stubs(count_srcsets: 3)

    OutputFormats::DataPicture.expects(:new)

    OutputFormats::DataAuto.new
  end
end
