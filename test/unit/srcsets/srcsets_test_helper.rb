require 'test_helper'
require 'jekyll_picture_tag'

module SrcsetTestHelper
  include TestHelper
  include PictureTag

  def setup
    [100, 150, 200, 300].each { |i| stub_generated(i, gstub(i)) }
    PictureTag::Pool.start_pool
    PictureTag.stubs(config)
  end

  def before_teardown
    PictureTag::Pool.stop_pool
  end

  def source_image
    @source_image ||= SourceImageStub.new(
      width: 1000, shortname: 'some name', digest: 'aaaaa', ext: 'jpg',
      media_preset: 'mobile'
    )
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

  def stub_generated(width, returns, format = 'original')
    GeneratedImage.stubs(:new)
                  .with(source_file: source_image, width: width, format: format)
                  .returns(returns)
  end
end
