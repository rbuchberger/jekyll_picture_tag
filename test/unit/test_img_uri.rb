require 'test_helper'
class ImgUriTest < Minitest::Test
  include PictureTag
  include TestHelper

  # setup
  def setup
    @pconfig = {
      'source' => 'source-dir',
      'output' => 'output-dir',
      'baseurl_key' => 'baseurl'
    }

    @config = {
      'url' => 'example.com'
    }
    PictureTag.stubs(
      cdn?: false,
      pconfig: @pconfig,
      config: @config
    )
  end

  def tested(param = 'img.jpg', source_image: false)
    ImgURI.new(param, source_image: source_image).to_s
  end

  # relative url
  def test_relative
    @pconfig['relative_url'] = true

    assert_equal '/output-dir/img.jpg', tested
  end

  # absolute url
  def test_absolute
    assert_equal 'example.com/output-dir/img.jpg', tested
  end

  # cdn url
  def test_cdn
    PictureTag.stubs(:cdn?).returns true
    @pconfig['cdn_url'] = 'some-cdn.net'

    assert_equal 'some-cdn.net/output-dir/img.jpg', tested
  end

  # with baseurl
  def test_baseurl
    @config['baseurl'] = 'some-baseurl'

    assert_equal 'example.com/some-baseurl/output-dir/img.jpg', tested
  end

  def test_ignore_baseurl
    @config['baseurl'] = 'some-baseurl'
    @pconfig['ignore_baseurl'] = true

    assert_equal 'example.com/output-dir/img.jpg', tested
  end

  def test_baseurl_key
    @pconfig['baseurl_key'] = 'foo'
    @config['foo'] = 'some-baseurl'

    assert_equal 'example.com/some-baseurl/output-dir/img.jpg', tested
  end

  # source image
  def test_source_image
    assert_equal 'example.com/source-dir/img.jpg',
                 tested('img.jpg', source_image: true)
  end

  # url encoding
  def test_url_encoding
    param = 'white space.jpg'
    assert_equal 'example.com/output-dir/white%20space.jpg', tested(param)
  end
end
