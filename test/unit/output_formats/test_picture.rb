require 'test_helper'
require_relative './output_format_test_helper'

class TestPicture < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::Picture.new
  end

  # basic picture element
  def test_picture
    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # one source multiple formats
  def test_multiple_formats
    two_format_setup

    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="webp">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # one format multiple sources
  def test_multiple_images
    two_image_setup

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" srcset="ss mobile" type="original">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # multiple of both
  def test_picture_multiple
    four_source_setup

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" srcset="ss mobile" type="webp">
        <source srcset="ss" type="webp">
        <source media="mquery" srcset="ss mobile" type="original">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # pixel ratio srcsets
  def test_picture_pixelratio
    pixel_ratio_setup
    stub_pixel_srcset

    correct = <<~HEREDOC
      <picture>
        <source srcset="pixel srcset" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # picture attrs
  def test_picture_attrs
    PictureTag.stubs(:html_attributes).returns('picture' => 'class="picture"')

    correct = <<~HEREDOC
      <picture class="picture">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # parent attrs
  def test_parent_attrs
    PictureTag.stubs(:html_attributes).returns('parent' => 'class="parent"')

    correct = <<~HEREDOC
      <picture class="parent">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # alt text
  def test_alt_text
    PictureTag.stubs(:html_attributes).returns('alt' => 'alt text')

    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="original">
        <img src="good_url" alt="alt text">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # all element attrs (given)
  def test_multiple_attrs
    PictureTag.stubs(:html_attributes).returns(
      'picture' => 'class="picture"',
      'parent' => 'class="parent"',
      'source' => 'class="source"',
      'img' => 'class="img"',
      'alt' => 'alt text'
    )

    correct = <<~HEREDOC
      <picture class="picture parent">
        <source class="source" srcset="ss" type="original">
        <img class="img" src="good_url" alt="alt text">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # sizes attr
  def test_sizes_srcset
    stub_sizes_srcset

    correct = <<~HEREDOC
      <picture>
        <source sizes="correct sizes" srcset="width srcset" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # anchor tag wrapper
  def test_anchor
    PictureTag.stubs(:html_attributes).returns('link' => 'some url')

    correct = <<~HEREDOC
      <a href="some url">
        <picture>
          <source srcset="ss" type="original">
          <img src="good_url">
        </picture>
      </a>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # nomarkdown

  def test_nomarkdown
    PictureTag.stubs(:nomarkdown? => true,
                     'html_attributes' => { 'link' => 'some url' })

    correct = <<~HEREDOC
      {::nomarkdown}<a href="some url"><picture><source srcset="ss" type="original"><img src="good_url"></picture></a>{:/nomarkdown}
    HEREDOC
    correct.delete!("\n")

    assert_equal correct, @tested.to_s
  end
end
