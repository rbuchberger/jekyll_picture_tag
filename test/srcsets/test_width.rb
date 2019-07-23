require 'test_helper'

class TestSrcsetWidth < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @source_image = SourceImageStub.new(width: 1000, shortname: 'some name')

    PictureTag.stubs(source_images:
                     { nil => @source_image },
                     preset: {
                       widths: [100, 200, 300]
                     })

    @tested = Srcsets::Width.new(
      media: 'mobile',
      format: 'some format'
    )
  end

  # basic srcset
  # srcset with sizes
  # srcset mime type
  # media query name
  # media attribute
  # small source
end
