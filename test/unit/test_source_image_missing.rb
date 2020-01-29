require 'test_helper'

class TestSourceImageMissing < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    PictureTag.stubs(:continue_on_missing?).returns(true)
    PictureTag.stubs(:fast_build?).returns(false)
    Utils.stubs(:warning)
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(false)

    @tested = SourceImage.new('img.jpg')
  end

  # digest_missing
  def test_digest
    assert_equal 'x' * 6, @tested.digest
  end

  # size missing
  def test_width
    assert_equal 999_999, @tested.width
  end

  def test_warning
    Utils.expects(:warning)

    SourceImage.new('img.jpg')
  end

  # grab_file missing
  def test_grab_missing_file
    assert SourceImage.new('img.jpg').missing
  end
end
