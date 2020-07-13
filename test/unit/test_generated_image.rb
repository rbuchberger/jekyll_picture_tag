require 'test_helper'

class GeneratedImageTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @destfile = '/tmp/jpt/img-100-aaaaaa.webp'
    PictureTag.stubs(:dest_dir).returns('/tmp/jpt')
    PictureTag.stubs(:fast_build?).returns(false)
    File.stubs(:exist?).with(@destfile).returns true

    @source_stub = SourceImageStub.new(base_name: 'img',
                                       name: '/tmp/jpt/img.jpg',
                                       missing: false,
                                       digest: 'a' * 6,
                                       ext: 'jpg',
                                       digest_guess: nil)
  end

  def tested
    GeneratedImage
      .new(source_file: @source_stub, width: 100, format: 'webp')
  end

  def test_init_existing_dest
    GeneratedImage.any_instance.expects(:generate).never

    tested
  end

  def test_name
    assert_equal 'img-100-aaaaaa.webp', tested.name
  end

  # absolute filename
  def test_absolute_filename
    assert_equal '/tmp/jpt/img-100-aaaaaa.webp',
                 tested.absolute_filename
  end

  def test_format
    assert_equal '.webp', File.extname(tested.name)
  end

  def test_format_original
    File.stubs(:exist?).returns true
    format = GeneratedImage
             .new(source_file: @source_stub, width: 100, format: 'original')
             .format

    assert_equal 'jpg', format
  end
end
