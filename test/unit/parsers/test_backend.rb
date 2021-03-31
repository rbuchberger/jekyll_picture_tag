require 'test_helper'

class TestImageBackend
  def tested
    Parsers::ImageBackend.new
  end

  def test_vips_formats
    assert_includes tested.vips_formats, 'vips'
  end

  def test_magick_formats
    assert_includes tested.magick_formats, 'jpeg'
  end
end
