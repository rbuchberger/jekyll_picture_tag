require 'test_helper'
require 'jekyll_picture_tag'

# The fact that these stubs are so complicated is probably one of those code
# smell things I keep hearing about.
module OutputFormatTestHelper
  include PictureTag
  include TestHelper

  def base_stubs
    PictureTag::Pool.start_test_pool
    PictureTag.stubs(config)
    stub_srcsets
    stub_generated_image
  end

  def config
    {
      preset: preset,
      source_images: [basic_source_stub],
      formats: %w[original],
      fallback_format: 'fallback format',
      fallback_width: 100,
      crop: nil,
      keep: 'center',
      html_attributes: {},
      nomarkdown?: false
    }
  end

  def preset
    { 'widths' => [100, 200, 300], 'data_sizes' => true }
  end

  def pixel_ratio_preset
    { 'pixel_ratios' => [1, 1.5, 2], 'base_width' => 100 }
  end

  def stub_generated_image
    GeneratedImage.stubs(:new).returns(
      GeneratedImageStub.new(name: 'generated.img', uri: 'good_url', width: 999)
    )
  end

  def basic_source_stub
    @basic_source_stub ||= SourceImageStub.new(
      name: 'img.jpg', media_preset: nil, width: 2000
    )
  end

  def media_source_stub
    @media_source_stub ||= SourceImageStub.new(
      name: 'mobile.jpg',
      media_preset: 'mobile',
      width: 2000
    )
  end

  def stub_pixel_srcset
    Srcsets::PixelRatio.stubs(:new).with(basic_source_stub, 'original').returns(
      SrcsetStub.new(nil, 'pixel srcset', nil, 'original')
    )
  end

  def stub_width_srcset
    Srcsets::Width.stubs(:new).with(basic_source_stub, 'original').returns(
      SrcsetStub.new(nil, 'width srcset', nil, 'original')
    )
  end

  def stub_sizes_srcset
    Srcsets::Width.stubs(:new).returns(
      SrcsetStub.new('correct sizes', 'width srcset', nil, 'original')
    )
  end

  def stub_srcsets
    Srcsets::Basic.stubs(:new).with(media_source_stub, 'webp').returns(
      SrcsetStub.new(nil, 'ss mobile', 'mobile', 'webp', 'mquery')
    )

    Srcsets::Basic.stubs(:new).with(basic_source_stub, 'webp').returns(
      SrcsetStub.new(nil, 'ss', nil, 'webp')
    )

    Srcsets::Basic.stubs(:new).with(media_source_stub, 'original').returns(
      SrcsetStub.new(nil, 'ss mobile', 'mobile', 'original', 'mquery')
    )

    Srcsets::Basic.stubs(:new).with(basic_source_stub, 'original').returns(
      SrcsetStub.new(nil, 'ss', nil, 'original')
    )
  end
end
