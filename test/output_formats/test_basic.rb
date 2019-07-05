require 'test_helper'

class TestOutputFormatBasic < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @tested = OutputFormats::Basic.new
  end

  # build_base_img
  def test_build_base_img
    tag_stub = SingleTagStub.new('img', [])
    fallback_stub = SingleTagStub.new('fallback')
    SingleTag.stubs(:new).with('img').returns(tag_stub)
    PictureTag.stubs(:html_attributes).returns(
      'img' => 'img attributes', 'implicit' => 'implicit attributes',
      'alt' => 'alt text'
    )
    @tested.stubs(:build_fallback_image).returns(fallback_stub)

    @tested.expects(:add_src).with(tag_stub, 'fallback')
    @tested.expects(:add_alt).with(tag_stub, 'alt text')
    assert_equal tag_stub, @tested.build_base_img
  end

  # to_s
  def test_to_s
    @tested.stubs(:base_markup).returns('base markup')
    @tested.stubs(:wrap).with('base markup').returns(:wrapped_markup)

    assert_equal 'wrapped_markup', @tested.to_s
  end

  # wrap
  def test_wrap
    PictureTag.stubs(:html_attributes).returns('link' => 'good link')
    PictureTag.stubs(:nomarkdown?).returns(true)

    @tested.expects(:anchor_tag).with('markup').returns('<a>markup</a>')
    @tested.expects(:nomarkdown_wrapper).with('<a>markup</a>')
           .returns('wrapped markup')

    assert_equal 'wrapped markup', @tested.send(:wrap, 'markup')
  end

  def test_skip_wrap
    PictureTag.stubs(:html_attributes).returns('link' => nil)

    assert_equal 'correct', @tested.send(:wrap, 'correct')
  end

  # build_srcset
  def test_build_srcset_with_ratio
    PictureTag.stubs(:preset).returns('pixel_ratios' => [1, 2])

    PictureTag::Srcsets::PixelRatio
      .expects(:new)
      .with(media: 'test media', format: 'test format')

    @tested.send(:build_srcset, 'test media', 'test format')
  end

  def test_build_srcset_width
    PictureTag.stubs(:preset).returns({})

    PictureTag::Srcsets::Width
      .expects(:new)
      .with(media: 'test media', format: 'test format')

    @tested.send(:build_srcset, 'test media', 'test format')
  end

  # add_src
  def test_add_src
    dummy = Object.new

    PictureTag.stubs(:build_url).with('some name').returns('good src')
    dummy.expects(:src=).with('good src')

    @tested.send(:add_src, dummy, 'some name')
  end

  # add_srcset
  def test_add_srcset
    dummy_srcset = Object.new
    dummy_srcset.stubs(:to_s).returns('good srcset')

    dummy_element = Object.new
    dummy_element.expects(:srcset=).with('good srcset')

    @tested.send(:add_srcset, dummy_element, dummy_srcset)
  end

  # add_sizes
  def test_add_sizes
    dummy_srcset = Object.new
    dummy_srcset.stubs(:sizes).returns('good sizes')

    dummy_element = Object.new
    dummy_element.expects(:sizes=).with('good sizes')

    @tested.send(:add_sizes, dummy_element, dummy_srcset)
  end

  # add_alt
  def test_add_alt
    dummy = Object.new
    dummy.expects(:alt=).with('alt text')

    @tested.send(:add_alt, dummy, 'alt text')
  end

  # add_media
  def test_add_media
    dummy_srcset = Object.new
    dummy_srcset.stubs(:media).returns('yes')
    dummy_srcset.stubs(:media_attribute).returns('good attribute')

    dummy_element = Object.new
    dummy_element.expects(:media=).with('good attribute')

    @tested.send(:add_media, dummy_element, dummy_srcset)
  end

  # build_fallback_image
  def test_build_fallback_image
    PictureTag.stubs(:source_images).returns(nil => 'source image')
    PictureTag.stubs(:fallback_format).returns('fallback format')
    PictureTag.stubs(:fallback_width).returns('fallback width')

    GeneratedImage.expects(:new).with(source_file: 'source image',
                                      format: 'fallback format',
                                      width: 'fallback width')

    @tested.send(:build_fallback_image)
  end

  # nomarkdown_wrapper
  def test_nomarkdown_wrapper
    assert_equal '{::nomarkdown}some content{:/nomarkdown}',
                 @tested.send(:nomarkdown_wrapper, "some \ncontent\n")
  end

  # anchor tag
  def test_anchor_tag
    dummy_element = Object.new
    dummy_attributes = Object.new
    dummy_content = Object.new

    DoubleTag.expects(:new).with('a').returns(dummy_element)

    PictureTag.stubs(:html_attributes).returns('a' => 'good attributes',
                                                 'link' => 'good link')
    dummy_element.expects(:href=).with('good link')
    dummy_element.expects(:attributes).returns(dummy_attributes)

    dummy_attributes.expects(:<<).with('good attributes')

    dummy_content.expects(:add_parent).with(dummy_element)

    @tested.send(:anchor_tag, dummy_content)
  end
end
