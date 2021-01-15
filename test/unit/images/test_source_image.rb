require 'test_helper'

class TestSourceImage < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    PictureTag.stubs(:fast_build?).returns(false)
    Cache::Source.stubs(:new).returns(cache_stub)
    File.stubs(:read)
    Vips::Image.stubs(:new_from_file).returns(ImageStub.new(50, 60))
    Digest::MD5.stubs(:hexdigest)
               .returns('abc123')
    File.stubs(:exist?).returns(true)
  end

  def cache_stub
    @cache_stub ||= { width: 88, height: 100, digest: 'abc123' }
  end

  def tested
    @tested ||= SourceImage.new('img.jpg', 'media preset')
  end

  def test_digest
    Digest::MD5.unstub(:hexdigest)
    az = ('a'..'z').to_a.join

    File.stubs(:read).with('/home/loser/img.jpg').returns('some file')
    Digest::MD5.stubs(:hexdigest)
               .with('some file')
               .returns(az)

    cache_stub.stubs(:write)
    assert_equal tested.digest, az
  end

  def test_update_cache
    cache_stub[:digest] = 'bad info'

    cache_stub.expects(:[]=).with(:digest, 'abc123')
    cache_stub.expects(:[]=).with(:width, 50)
    cache_stub.expects(:[]=).with(:height, 60)
    cache_stub.expects(:write)

    tested
  end

  def test_name
    assert_equal '/home/loser/img.jpg', tested.name
  end

  def test_base_name
    assert_equal 'img', tested.base_name
  end

  def test_ext
    assert_equal 'jpg', tested.ext
  end

  def test_width_existing
    image_stub = Object.new
    image_stub.stubs(:width).returns(88)

    Vips::Image
      .stubs(:new_from_file).with('/home/loser/img.jpg').returns(image_stub)

    assert_equal 88, tested.width
  end

  def test_height_existing
    image_stub = Object.new
    image_stub.stubs(:height).returns(100)

    Vips::Image
      .stubs(:new_from_file).with('/home/loser/img.jpg').returns(image_stub)

    assert_equal 100, tested.height
  end

  def test_grab_file
    File.unstub(:exist?)
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(true)

    assert_equal '/home/loser/img.jpg', tested.name
  end

  def test_grab_missing_file_raise_error
    File.unstub(:exist?)
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(false)
    PictureTag.stubs(:continue_on_missing?).returns(false)

    assert_raises ArgumentError do
      SourceImage.new('img.jpg')
    end
  end

  def test_media_preset
    assert_equal 'media preset', tested.media_preset
  end

  def test_fastbuild_off
    cache_stub.stubs(:write)
    Digest::MD5.expects(:hexdigest)

    tested
  end

  def test_fastbuild_on
    PictureTag.stubs(:fast_build?).returns(true)

    Digest::MD5.expects(:hexdigest).never

    tested
  end
end
