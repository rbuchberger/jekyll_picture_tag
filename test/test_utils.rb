require 'minitest/autorun'
require 'jekyll_picture_tag'

class TestUtils < Minitest::Test
  include PictureTag

  def test_titleize
    assert_equal Utils.titleize('snake_case'), 'SnakeCase'
  end
end
