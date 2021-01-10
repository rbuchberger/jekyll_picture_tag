require_relative './output_format_test_helper'

class TestDataPicture < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::DataPicture.new
  end

  # basic picture element
  def test_picture
    correct = <<~HEREDOC
      <picture>
        <source data-srcset="ss" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # multiple of both
  def test_picture_multiple
    four_source_setup

    correct = <<~HEREDOC
      <picture>
        <source media="mquery" data-srcset="ss mobile" type="webp">
        <source data-srcset="ss" type="webp">
        <source media="mquery" data-srcset="ss mobile" type="original">
        <source data-srcset="ss" type="original">
        <img data-src="good_url">
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
        <source data-srcset="pixel srcset" type="original">
        <img data-src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
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

    assert_equal correct, @tested.to_s
  end
end
