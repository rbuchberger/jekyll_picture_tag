require 'test_helper'
require_relative './test_helper_output'

class TestOutputFormatImg < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    stub_srcset
    stub_generated_image
    stub_picture_tag

    PictureTag.stubs(source_images: { nil => 'img.jpg' },
                     formats: ['original'])

    @tested = OutputFormats::Img.new
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
      SrcsetStub.new('correct sizes', 'width srcset')
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
  def test_anchor_tag
    PictureTag.stubs(:html_attributes)
              .returns('link' => 'some link')

    correct = <<~HEREDOC
      <a href="some link">
        <img src="good_url" srcset="srcset">
      </a>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # anchor with attributes
  def test_anchor_with_attrs
    PictureTag.stubs(:html_attributes)
              .returns('link' => 'some link', 'a' => 'class="anchor"')

    correct = <<~HEREDOC
      <a class="anchor" href="some link">
        <img src="good_url" srcset="srcset">
      </a>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # nomarkdown wrapper autodetection
  # Setting is true, but with no link it shouldn't wrap
  def test_nomarkdown_wrapper_autodetect
    PictureTag.stubs(:nomarkdown?).returns(true)

    correct = <<~HEREDOC
      <img src="good_url" srcset="srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # setting is true, with link. Should get oneline with wrapper
  def test_nomarkdown_wrapper
    PictureTag.stubs(:nomarkdown? => true,
                     'html_attributes' => { 'link' => 'some link' })

    correct = <<~HEREDOC
      {::nomarkdown}<a href="some link"><img src="good_url" srcset="srcset"></a>{:/nomarkdown}
    HEREDOC
    correct.delete!("\n")

    assert_equal correct, @tested.to_s
  end
end
