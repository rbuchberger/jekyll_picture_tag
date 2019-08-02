require 'test_helper'
class ImgUriTest < Minitest::Test
  include PictureTag
  include TestHelper

  # setup
  def setup
    @pconfig = {
      'source' => 'source-dir',
      'output' => 'output-dir'
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

  def tested
    ImgURI.new('img.jpg').to_s
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

  # source image
  def test_source_image
    assert_equal 'example.com/source-dir/img.jpg',
                 ImgURI.new('img.jpg', source_image: true).to_s
  end
end
