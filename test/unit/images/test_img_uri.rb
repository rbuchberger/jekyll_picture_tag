require 'test_helper'
class ImgUriTest < Minitest::Test
  include PictureTag
  include TestHelper

  # Lifecycle

  def setup
    PictureTag.stubs config
  end

  # Helpers

  def config
    {
      cdn?: false,
      relative_url: true,
      pconfig: {
        'source' => 'source-dir',
        'output' => 'output-dir'
      },
      config: {
        'url' => 'example.com'
      }
    }
  end

  def tested(param = 'img.jpg', source_image: false)
    ImgURI.new(param, source_image: source_image).to_s
  end

  # Tests

  def test_relative
    assert_equal '/output-dir/img.jpg', tested
  end

  def test_absolute
    PictureTag.stubs(relative_url: false)
    assert_equal 'example.com/output-dir/img.jpg', tested
  end

  def test_cdn
    PictureTag.stubs(cdn?: true, cdn_url: 'https://some-cdn.net')

    assert_equal 'https://some-cdn.net/output-dir/img.jpg', tested
  end

  def test_baseurl
    PictureTag.stubs(baseurl: 'some-baseurl')

    assert_equal '/some-baseurl/output-dir/img.jpg', tested
  end

  def test_source_image
    assert_equal '/source-dir/img.jpg',
                 tested('img.jpg', source_image: true)
  end

  def test_url_encoding
    param = 'white space.jpg'
    assert_equal '/output-dir/white%20space.jpg', tested(param)
  end
end
