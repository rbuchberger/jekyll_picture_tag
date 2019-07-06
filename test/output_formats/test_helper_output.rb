require 'test_helper'

module OutputFormatTestHelper
  include TestHelper

  def base_stubs
    stub_srcsets
    stub_generated_image
    stub_picture_tag

    PictureTag.stubs(
      source_images: { nil => 'img.jpg' },
      formats: %w[original]
    )
  end

  def stub_generated_image
    PictureTag::GeneratedImage
      .stubs(:new)
      .returns(GeneratedImageStub.new(name: 'generated.img', width: 999))
  end

  def stub_picture_tag
    PictureTag.stubs(fallback_format: 'fallback format',
                     fallback_width: 100,
                     preset: { 'widths' => [100, 200, 300] },
                     build_url: 'good_url',
                     html_attributes: {},
                     nomarkdown?: false)
  end

  def stub_pixel_srcset
    PictureTag::Srcsets::PixelRatio
      .stubs(:new).with(media: nil, format: 'original')
      .returns(SrcsetStub.new(nil, 'pixel srcset', nil, 'original'))
  end

  def stub_width_srcset
    PictureTag::Srcsets::Width
      .stubs(:new).with(media: nil, format: 'original')
      .returns(SrcsetStub.new(nil, 'width srcset', nil, 'original'))
  end

  def stub_sizes_srcset
    PictureTag::Srcsets::Width
      .stubs(:new)
      .returns(SrcsetStub.new('correct sizes', 'width srcset', nil, 'original'))
  end

  def stub_srcsets
    PictureTag::Srcsets::Basic
      .stubs(:new).with(media: 'mobile', format: 'webp')
      .returns(SrcsetStub.new(nil, 'ss mobile', 'mobile', 'webp', 'mquery'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(media: nil, format: 'webp')
      .returns(SrcsetStub.new(nil, 'ss', nil, 'webp'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(media: 'mobile', format: 'original')
      .returns(SrcsetStub.new(nil, 'ss mobile', 'mobile', 'original', 'mquery'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(media: nil, format: 'original')
      .returns(SrcsetStub.new(nil, 'ss', nil, 'original'))
  end

  def four_source_setup
    PictureTag
      .stubs(source_images: { nil => 'img.jpg', 'mobile' => 'mobile.jpg' },
             formats: %w[webp original])
  end

  def two_format_setup
    PictureTag
      .stubs(formats: %w[webp original])
  end

  def two_image_setup
    PictureTag
      .stubs(source_images: { nil => 'img.jpg', 'mobile' => 'mobile.jpg' })
  end

  def pixel_ratio_setup
    PictureTag
      .stubs(:preset)
      .returns('pixel_ratios' => [1, 1.5, 2], 'base_width' => 100)
  end
end
