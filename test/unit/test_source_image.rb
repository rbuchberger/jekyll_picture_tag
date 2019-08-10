require 'test_helper'

class TestSourceImage < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    File.stubs(:exist?).returns(true)

    @tested = SourceImage.new('img.jpg', 'media preset')
  end

  def test_digest
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

  def test_size_existing
    FastImage.stubs(:size).with('/home/loser/img.jpg').returns([88, 99])

    assert_equal({ width: 88, height: 99 }, @tested.size)
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
