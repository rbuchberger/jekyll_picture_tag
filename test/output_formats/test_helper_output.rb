require 'test_helper'

module OutputFormatTestHelper
  include TestHelper

  def stub_srcset
    PictureTag::Srcsets::Basic
      .stubs(:new)
      .returns(SrcsetStub.new(nil, 'srcset', nil, 'some type'))
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

  def pixel_ratio_stub
    SrcsetStub.new(nil, 'pixel srcset', nil, 'some type')
  end

  def width_stub
    SrcsetStub.new(nil, 'width srcset', nil, 'some type')
  end
end
