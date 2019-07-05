require 'test_helper'

class TestSourceImage < Minitest::Test
  include PictureTag
  include TestHelper

  def setup_existing
    PictureTag.stubs(:source_dir).returns('/dev/')
    File.stubs(:exist?).returns(true)

    SourceImage.new('urandom.jpg')
  end

  def setup_missing
    PictureTag.stubs(:source_dir).returns('/dev/')
    PictureTag.stubs(:continue_on_missing?).returns(true)
    Utils.stubs(:warning)
    File.stubs(:exist?).returns(false)

    SourceImage.new('urandom.jpg')
  end

  # digest_existing
  def test_digest_existing
    Digest::MD5.stubs(:hexdigest).returns(('a'..'z').to_a.join)
    File.stubs(:read).returns('i am a file i swear')

    assert_equal ('a'..'f').to_a.join, setup_existing.digest
  end

  # digest_missing
  def test_digest_missing
    assert_equal  'x' * 6, setup_missing.digest
  end

  # basename
  def test_base_name
    assert_equal 'urandom', setup_existing.base_name
  end

  # ext
  def test_ext
    assert_equal 'jpg', setup_existing.ext
  end

  # size existing
  def test_size_existing
    FastImage.stubs(:size).with('/dev/urandom.jpg').returns([88, 99])

    assert_equal({ width: 88, height: 99 }, setup_existing.size)
  end

  # size missing
  def test_size_missing
    assert_equal({ width: 999_999, height: 999_999 }, setup_missing.size)
  end

  # grab_file existing
  def test_grab_file_existing
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    File.stubs(:exist?).with('/home/loser/image.jpg').returns(true)

    assert_equal '/home/loser/image.jpg', SourceImage.new('image.jpg').name
  end

  # grab_file missing
  def test_grab_file_missing_continue
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    File.stubs(:exist?).with('/home/loser/image.jpg').returns(false)
    PictureTag.stubs(:continue_on_missing?).returns(true)

    Utils.expects(:warning)
    assert SourceImage.new('image.jpg').missing
  end

  def test_grab_file_missing_abort
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    File.stubs(:exist?).with('/home/loser/image.jpg').returns(false)
    PictureTag.stubs(:continue_on_missing?).returns(false)

    assert_raises ArgumentError do
      SourceImage.new('image.jpg')
    end
  end
end
