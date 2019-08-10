require 'test_helper'
class TagParserTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    stub_template_parsing
  end

  def tested(params = 'img.jpg')
    Instructions::TagParser.new(params)
  end

  # default preset name
  def test_default
    assert_equal 'default', tested.preset_name
  end

  # given preset name
  def test_given_preset
    assert_equal 'preset', tested('preset img.jpg').preset_name
  end

  # base image
  def test_base_image
    assert_equal 'img.jpg', tested.source_names.first
  end

  # media images
  def test_media_images
    params = 'img.jpg mobile: mobile.jpg'
    assert_equal 'mobile.jpg', tested(params).source_names[1]
  end

  # base image with whitespace in filename
  def test_base_whitespace
    assert_equal 'white space.jpg',
                 tested('"white space.jpg"').source_names.first
  end

  # media queries with whitespace in filename
  def test_media_whitespace
    params = 'img.jpg mobile: "white space.jpg"'

    assert_equal 'white space.jpg', tested(params).source_names[1]
  end

  def test_escaped_space
    params = 'white\\ space.jpg'
    assert_equal 'white space.jpg', tested(params).source_names.first
  end

  # leftovers
  def test_leftovers
    correct = ['--picture', 'class="some class"']
    params = 'img.jpg mobile: mobile.jpg --picture class="some class"'
    assert_equal correct, tested(params).leftovers
  end
end
