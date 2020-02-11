require 'test_helper'

module TestHelperSrcset
  include TestHelper
  include PictureTag

  def build_source_stub
    @source_image = source_stub
  end

  def source_stub
    SourceImageStub.new(
      width: 1000, shortname: 'some name', digest: 'aaaaa', ext: 'jpg',
      media_preset: 'mobile'
    )
  end

  def build_genstubs
    [100, 150, 200, 300].each { |i| stub_generated(i, gstub(i)) }
  end

  def gstub(width, exists: false)
    GeneratedImageStub.new(
      name: "img-#{width}-aaaaa.jpg",
      uri: "/img-#{width}-aaaaa.jpg",
      width: width,
      format: 'jpg',
      exists?: exists
    )
  end

  def stub_generated(
    width, returns, format = 'original', crop: nil, gravity: 'center'
  )
    GeneratedImage.stubs(:new)
                  .with(source_file: @source_image, width: width,
                        format: format, crop: crop, gravity: gravity)
                  .returns(returns)
  end
end
