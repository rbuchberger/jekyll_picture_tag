require_relative 'output_format_test_helper'

class TestPicture < Minitest::Test
  include OutputFormatTestHelper

  # Lifecycle

  def setup
    base_stubs
  end

  # Helpers

  def tested
    @tested ||= OutputFormats::Picture.new
  end

  # Test cases

  def test_picture
    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_multiple_formats
    PictureTag.formats.prepend 'webp'

    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="webp">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_multiple_images
    PictureTag.source_images << media_source_stub

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" srcset="ss mobile" type="original">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_picture_multiple
    PictureTag.source_images << media_source_stub
    PictureTag.formats.prepend 'webp'

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" srcset="ss mobile" type="webp">
        <source srcset="ss" type="webp">
        <source media="mquery" srcset="ss mobile" type="original">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_picture_pixelratio
    PictureTag.preset.merge! pixel_ratio_preset
    stub_pixel_srcset

    correct = <<~HEREDOC
      <picture>
        <source srcset="pixel srcset" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_picture_attrs
    PictureTag.html_attributes.merge!('picture' => 'class="picture"')

    correct = <<~HEREDOC
      <picture class="picture">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_parent_attrs
    PictureTag.html_attributes.merge!('parent' => 'class="parent"')

    correct = <<~HEREDOC
      <picture class="parent">
        <source srcset="ss" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_alt_text
    PictureTag.html_attributes.merge!('alt' => 'alt text')

    correct = <<~HEREDOC
      <picture>
        <source srcset="ss" type="original">
        <img src="good_url" alt="alt text">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_multiple_attrs
    PictureTag.html_attributes.merge!({
                                        'picture' => 'class="picture"',
                                        'parent' => 'class="parent"',
                                        'source' => 'class="source"',
                                        'img' => 'class="img"',
                                        'alt' => 'alt text'
                                      })

    correct = <<~HEREDOC
      <picture class="picture parent">
        <source class="source" srcset="ss" type="original">
        <img class="img" src="good_url" alt="alt text">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_sizes_srcset
    stub_sizes_srcset

    correct = <<~HEREDOC
      <picture>
        <source sizes="correct sizes" srcset="width srcset" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_anchor
    PictureTag.html_attributes.merge!({ 'link' => 'some url' })

    correct = <<~HEREDOC
      <a href="some url">
        <picture>
          <source srcset="ss" type="original">
          <img src="good_url">
        </picture>
      </a>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_nomarkdown
    PictureTag.html_attributes.merge!({ 'link' => 'some url' })
    PictureTag.stubs(nomarkdown?: true)

    correct = <<~HEREDOC
      {::nomarkdown}
      <a href="some url"><picture><source srcset="ss" type="original"><img src="good_url"></picture></a>
      {:/nomarkdown}
    HEREDOC
    correct.delete!("\n")

    assert_equal correct, tested.to_s
  end
end
