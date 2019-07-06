require 'test_helper'

class TestSourceImageMissing < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    PictureTag.stubs(:continue_on_missing?).returns(true)
    Utils.stubs(:warning)
    File.stubs(:exist?).returns(false)

    @tested = SourceImage.new('img.jpg')
  end

  # digest_missing
  def test_digest
    assert_equal 'x' * 6, @tested.digest
  end

  # size missing
  def test_size
    assert_equal({ width: 999_999, height: 999_999 }, @tested.size)
  end

  # grab_file missing
  def test_grab_missing_file
    PictureTag.stubs(:source_dir).returns('/home/loser/')
    File.stubs(:exist?).with('/home/loser/img.jpg').returns(false)
    PictureTag.stubs(:continue_on_missing?).returns(true)

    Utils.expects(:warning)
    assert SourceImage.new('img.jpg').missing
  end
end
