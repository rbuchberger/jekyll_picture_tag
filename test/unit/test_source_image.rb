require 'test_helper'

class TestSourceImage < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    PictureTag.stubs(:fast_build?).returns(false)
    Cache::Source.stubs(:new).returns({ width: 88, height: 100, digest: 'abc123' })
    File.stubs(:read)
    Digest::MD5.stubs(:hexdigest)
               .returns('abc123')
    File.stubs(:exist?).returns(true)

    @tested = SourceImage.new('img.jpg', 'media preset')
  end

  def test_digest
    skip

    Cache::Source.unstub(:new)
    Digest::MD5.unstub(:hexdigest)

    File.stubs(:read).with('/home/loser/img.jpg').returns('some file')
    Digest::MD5.stubs(:hexdigest)
               .with('some file')
               .returns(('a'..'z').to_a.join)

    assert_equal ('a'..'f').to_a.join, @tested.digest
  end

  def test_base_name
    assert_equal 'img', @tested.base_name
  end

  def test_ext
    assert_equal 'jpg', @tested.ext
  end

  def test_width_existing
    image_stub = Object.new
    image_stub.stubs(:width).returns(88)

    MiniMagick::Image
      .stubs(:open).with('/home/loser/img.jpg').returns(image_stub)

    assert_equal 88, @tested.width
  end

  def test_grab_file
    File.unstub(:exist?)
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(true)

    assert_equal '/home/loser/img.jpg', @tested.name
  end

  def test_grab_missing_file
    File.unstub(:exist?)
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(false)
    PictureTag.stubs(:continue_on_missing?).returns(false)

    assert_raises ArgumentError do
      SourceImage.new('img.jpg')
    end
  end

  def test_media_preset
    assert_equal 'media preset', @tested.media_preset
  end
end
