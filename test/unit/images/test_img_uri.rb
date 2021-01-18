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
      pconfig: {
        'source' => 'source-dir',
        'output' => 'output-dir',
        'baseurl_key' => 'baseurl'
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
    PictureTag.pconfig['relative_url'] = true

    assert_equal '/output-dir/img.jpg', tested
  end

  def test_absolute
    assert_equal 'example.com/output-dir/img.jpg', tested
  end

  def test_cdn
    PictureTag.stubs(cdn?: true)
    PictureTag.pconfig['cdn_url'] = 'some-cdn.net'

    assert_equal 'some-cdn.net/output-dir/img.jpg', tested
  end

  def test_baseurl
    PictureTag.config['baseurl'] = 'some-baseurl'

    assert_equal 'example.com/some-baseurl/output-dir/img.jpg', tested
  end

  def test_ignore_baseurl
    PictureTag.config['baseurl'] = 'some-baseurl'
    PictureTag.pconfig['ignore_baseurl'] = true

    assert_equal 'example.com/output-dir/img.jpg', tested
  end

  def test_baseurl_key
    PictureTag.pconfig['baseurl_key'] = 'foo'
    PictureTag.config['foo'] = 'some-baseurl'

    assert_equal 'example.com/some-baseurl/output-dir/img.jpg', tested
  end

  def test_source_image
    assert_equal 'example.com/source-dir/img.jpg',
                 tested('img.jpg', source_image: true)
  end

  def test_url_encoding
    param = 'white space.jpg'
    assert_equal 'example.com/output-dir/white%20space.jpg', tested(param)
  end
end
