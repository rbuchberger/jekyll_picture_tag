require_relative 'output_format_test_helper'

# Most of this functionality is capured in a normal Picture output; we only
# focus on the places where they differ.
class TestDataPicture < Minitest::Test
  include OutputFormatTestHelper

  def setup
    base_stubs
  end

  def tested
    @tested ||= OutputFormats::DataPicture.new
  end

  def test_picture
    correct = <<~HEREDOC
      <picture>
        <source data-srcset="ss" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_multiple_formats
    PictureTag.formats.prepend 'webp'
    PictureTag.source_images << media_source_stub

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" data-srcset="ss mobile" type="webp">
        <source data-srcset="ss" type="webp">
        <source media="mquery" data-srcset="ss mobile" type="original">
        <source data-srcset="ss" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  # pixel ratio srcsets
  def test_picture_pixelratio
    PictureTag.preset.merge! pixel_ratio_preset
    stub_pixel_srcset

    correct = <<~HEREDOC
      <picture>
        <source data-srcset="pixel srcset" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  # sizes attr
  def test_sizes_srcset
    stub_sizes_srcset

    correct = <<~HEREDOC
      <picture>
        <source data-sizes="correct sizes" data-srcset="width srcset" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, tested.to_s
  end
end
