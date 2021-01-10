require_relative './output_format_test_helper'

class TestImg < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::Img.new
  end

  # Test cases:
  # basic img
  def test_img
    correct = <<~HEREDOC
      <img src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with pixel ratio srcset
  def test_img_pixel_ratio
    pixel_ratio_setup
    stub_pixel_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="pixel srcset">
    HEREDOC
    assert_equal correct, @tested.to_s
  end

  # img with width srcset
  def test_width_srcset
    stub_width_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with srcset and sizes
  def test_srcset_and_sizes
    stub_sizes_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset" sizes="correct sizes">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with alt
  def test_alt
    PictureTag.stubs(:html_attributes).returns('alt' => 'alt text')

    correct = <<~HEREDOC
      <img src="good_url" alt="alt text" srcset="ss">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with parent attributes
  def test_parent
    PictureTag.stubs(:html_attributes).returns('parent' => 'class="parent"')

    correct = <<~HEREDOC
      <img src="good_url" srcset="ss" class="parent">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with img attributes
  def test_img_attrs
    PictureTag.stubs(:html_attributes).returns('img' => 'class="img"')

    correct = <<~HEREDOC
      <img class="img" src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with both img and parent attrs
  def test_both_attrs
    PictureTag.stubs(:html_attributes)
              .returns('img' => 'class="img"', 'parent' => 'class="parent"')

    correct = <<~HEREDOC
      <img class="img parent" src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # anchor tag wrapper
  def test_anchor_tag
    PictureTag.stubs(:html_attributes)
              .returns('link' => 'some link')

    correct = <<~HEREDOC
      <a href="some link">
        <img src="good_url" srcset="ss">
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
        <img src="good_url" srcset="ss">
      </a>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # setting is true, with link. Should get oneline with wrapper
  def test_nomarkdown_wrapper
    PictureTag.stubs(:nomarkdown? => true,
                     'html_attributes' => { 'link' => 'some link' })

    correct = <<~HEREDOC
      {::nomarkdown}<a href="some link"><img src="good_url" srcset="ss"></a>{:/nomarkdown}
    HEREDOC
    correct.delete!("\n")

    assert_equal correct, @tested.to_s
  end
end
