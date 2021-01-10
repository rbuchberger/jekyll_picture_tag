require 'test_helper'

class GeneratedImageMissingTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @destfile = '/home/loser/generated/img-100-xxxxxx.webp'
    PictureTag.stubs(:dest_dir).returns('/home/loser/generated')
    PictureTag.stubs(:fast_build?).returns(false)
    PictureTag.stubs(:quality).returns(75)
    Cache::Generated.stubs(:new).returns({ width: 200, height: 200 })
    File.stubs(:exist?)
        .with(@destfile).returns false

    @source_stub = SourceImageStub.new(base_name: 'img',
                                       name: '/home/loser/img.jpg',
                                       missing: true,
                                       digest: 'x' * 6,
                                       ext: 'jpg')
  end

  def tested
    GeneratedImage.new(source_file: @source_stub,
                       width: 100,
                       format: 'webp')
  end

  def test_init_missing_source
    GeneratedImage.any_instance.expects(:generate_image).never

    tested
  end

  def test_name
    assert_equal 'img-100-8fa2c9181.webp', tested.name
  end
end
