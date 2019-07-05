require 'test_helper'

class TestOutputFormatImg < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    GeneratedImage
      .stubs(:new)
      .returns(GeneratedImageStub.new(name: 'generated.img', width: 999))
    PictureTag::Srcsets::Basic
      .stubs(:new)
      .returns(SrcsetWidthStub.new(nil, 'srcset', nil))
    PictureTag.stubs(fallback_format: 'fallback format',
                     fallback_width: 100,
                     preset: { 'widths' => [100, 200, 300] },
                     source_images: { nil => 'img.jpg' },
                     formats: ['original'],
                     build_url: 'good_url',
                     html_attributes: {},
                     nomarkdown: false)

    @tested = OutputFormats::Img.new
  end

  def pixel_ratio_stub
    SrcsetWidthStub.new(nil, 'pixel srcset', nil)
  end

  def width_stub
    SrcsetWidthStub.new(nil, 'width srcset', nil)
  end

  # Test cases:
  # basic img
  def test_img
    correct = <<~HEREDOC
      <img src="good_url" srcset="srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with pixel ratio srcset
  def test_img_pixel_ratio
    PictureTag.stubs(:preset)
              .returns('pixel_ratios' => [1, 2], 'base_width' => 100)

    Srcsets::PixelRatio.expects(:new).returns(pixel_ratio_stub)
    correct = <<~HEREDOC
      <img src="good_url" srcset="pixel srcset">
    HEREDOC
    assert_equal correct, @tested.to_s
  end

  # img with width srcset
  def test_width_srcset
    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset">
    HEREDOC

    Srcsets::Width.expects(:new).returns(width_stub)
    assert_equal correct, @tested.to_s
  end

  # img with srcset and sizes
  def test_srcset_and_sizes
    Srcsets::Width.stubs(:new).returns(
      SrcsetWidthStub.new('correct sizes', 'width srcset')
    )

    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset" sizes="correct sizes">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with alt
  def test_alt
    PictureTag.stubs(:html_attributes).returns('alt' => 'alt text')

    correct = <<~HEREDOC
      <img src="good_url" alt="alt text" srcset="srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with parent attributes
  def test_parent
    PictureTag.stubs(:html_attributes).returns('parent' => 'class="parent"')

    correct = <<~HEREDOC
      <img src="good_url" srcset="srcset" class="parent">
    HEREDOC

    assert_equal correct, @tested.to_s
  end
  # img with img attributes

  def test_img_attrs
    PictureTag.stubs(:html_attributes).returns('img' => 'class="img"')

    correct = <<~HEREDOC
      <img class="img" src="good_url" srcset="srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with both img and parent attrs
  def test_both_attrs
    PictureTag.stubs(:html_attributes)
              .returns('img' => 'class="img"', 'parent' => 'class="parent"')

    correct = <<~HEREDOC
      <img class="img parent" src="good_url" srcset="srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # anchor tag wrapper
  # nomarkdown wrapper
end
