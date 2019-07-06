require 'test_helper'
require_relative './test_helper_output'

class TestOutputFormatPicture < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    stub_srcset
    stub_generated_image
    stub_picture_tag

    PictureTag.stubs(
      source_images: { nil => 'img.jpg' },
      formats: %w[original]
    )

    @tested = OutputFormats::Picture.new
  end

  # basic picture element
  def test_picture
    correct = <<~HEREDOC
      <picture>
        <source srcset="srcset" type="some type">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # one source multiple formats
  def test_picture_formats
    PictureTag.stubs(formats: %w[webp original])

    Srcsets::Width.stubs(:new).once.returns(SrcsetStub
      .new(nil, 'srcset', nil, 'original'))
    Srcsets::Width.stubs(:new).once.returns(SrcsetStub
      .new(nil, 'srcset', nil, 'webp'))

    correct = <<~HEREDOC
      <picture>
        <source srcset="srcset" type="webp">
        <source srcset="srcset" type="original">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # one format multiple sources
  def test_picture_sources
    PictureTag.stubs(
      source_images: { nil => 'img.jpg', 'mobile' => 'mobile.jpg' }
    )

    Srcsets::Width.stubs(:new).once.returns(SrcsetStub
      .new(nil, 'srcset mobile', true, 'type', 'mobile query'))
    Srcsets::Width.stubs(:new).once.returns(SrcsetStub
      .new(nil, 'srcset', nil, 'type'))

    correct = <<~HEREDOC
      <picture>
        <source media="mobile query" srcset="srcset mobile" type="type">
        <source srcset="srcset" type="type">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # multiple of both
  def test_picture_multiple
    PictureTag.stubs(
      source_images: { nil => 'img.jpg', 'mobile' => 'mobile.jpg' },
      formats: %w[original webp]
    )

    correct = <<~HEREDOC
      <picture>
        <source srcset="srcset" type="some type">
        <source srcset="srcset" type="some type">
        <source srcset="srcset" type="some type">
        <source srcset="srcset" type="some type">
        <img src="good_url">
      </picture>
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # pixel ratio srcsets
  def test_picture_pixelratio
    PictureTag.stubs(
      preset: { 'pixel_ratios' => [1, 1.5, 2], 'base_width' => 100 }
    )

    correct = <<~HEREDOC
      <picture>
        <source srcset="pixel srcset" type="some type">
        <img src="good_url">
      </picture>
    HEREDOC

    Srcsets::PixelRatio.expects(:new).returns(pixel_ratio_stub)
    assert_equal correct, @tested.to_s
  end
  # picture attrs
  # parent attrs
  # alt text
  # all element attrs (given)
  # sizes attr
end
