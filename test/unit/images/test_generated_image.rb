require 'test_helper'

# Tests of Generated Images, skipping actual image file generation.
class GeneratedImageTest < Minitest::Test
  include PictureTag
  include TestHelper

  # Lifecycle

  def setup
    PictureTag.stubs(config)
    GeneratedImage.any_instance.stubs(exists?: true)
    Cache::Generated.stubs(:new).returns({ width: 100, height: 80 })
  end

  # Helpers

  def tested
    @tested ||= GeneratedImage.new(source_file: source_stub,
                                   width: 100, format: 'webp')
  end

  def config
    { fast_build: false, quality: 75, dest_dir: temp_dir }
  end

  def destfile
    temp_dir 'img-100-aaaaaa.webp'
  end

  def source_stub
    @source_stub ||= SourceImageStub.new(base_name: 'img',
                                         name: temp_dir('img.jpg'),
                                         missing: false, digest: 'a' * 6,
                                         ext: 'jpg', digest_guess: nil,
                                         crop?: false)
  end

  # Tests

  def test_init_existing_dest
    ImageFile.expects(:new).never

    tested.generate
  end

  def test_init_missing_dest
    GeneratedImage.any_instance.stubs(exists?: false)

    ImageFile.expects(:new).once

    tested.generate
  end

  def test_name
    assert_equal 'img-100-e391bf5cd.webp', tested.name
  end

  def test_absolute_filename
    assert_equal temp_dir('img-100-e391bf5cd.webp'),
                 tested.absolute_filename
  end

  def test_format
    assert_equal '.webp', File.extname(tested.name)
  end

  def test_format_original
    format = GeneratedImage
             .new(source_file: source_stub, width: 100, format: 'original')
             .format

    assert_equal 'jpg', format
  end

  def test_source_width
    assert_equal 100, tested.source_width
  end

  def test_source_height
    assert_equal 80, tested.source_height
  end

  def test_uri
    uri_stub = Object.new
    uri_stub.expects(:to_s)

    ImgURI.expects(:new).with(tested.name).returns(uri_stub)

    tested.uri
  end
end
