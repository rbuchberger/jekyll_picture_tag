require 'test_helper'

# Tests of generated images, when the source image is missing. The fact that
# these tests need to exist say that GeneratedImage knows too much about
# SourceImage, which knows too much about its underlying source file. We need to
# refactor.
class GeneratedImageMissingTest < Minitest::Test
  include TestHelper
  include PictureTag

  # Lifecycle
  def setup
    PictureTag.stubs(config)
    File.stubs(:exist?).with(destfile).returns(false)
  end

  def tested
    GeneratedImage.new(source_file: source_stub, width: 100, format: 'webp')
  end

  # Helpers

  def config
    { dest_dir: '/home/loser/generated', fast_build: false, quality: 75 }
  end

  def destfile
    '/home/loser/generated/img-100-xxxxxx.webp'
  end

  def source_stub
    @source_stub ||= SourceImageStub.new(base_name: 'img',
                                         name: '/home/loser/img.jpg',
                                         missing: true, digest: 'x' * 6,
                                         ext: 'jpg')
  end

  # Tests

  def test_init_missing_source
    GeneratedImage.any_instance.expects(:generate_image).never

    tested
  end

  def test_name
    assert_equal 'img-100-8fa2c9181.webp', tested.name
  end
end
