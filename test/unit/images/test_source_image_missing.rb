require 'test_helper'

# This tests source images which have no corresponding source file. The fact
# that we have different test scenarios for the same class shows that it is
# doing too much and needs refactoring.
class TestSourceImageMissing < Minitest::Test
  include PictureTag
  include TestHelper

  # Lifecycle

  def setup
    PictureTag.stubs(config)
    Utils.stubs(:warning)
    Cache::Source.stubs(:new).returns({ width: nil, height: nil, digest: nil })
  end

  # Helpers

  def tested
    @tested ||= SourceImage.new('img.jpg')
  end

  def config
    {
      source_dir: temp_dir('does', 'not', 'exist'),
      continue_on_missing?: true,
      fast_build?: false
    }
  end

  # Tests

  def test_digest
    assert_equal '', tested.digest
  end

  # size missing
  def test_width
    assert_equal 999_999, tested.width
  end

  def test_height
    assert_equal 999_999, tested.height
  end

  def test_warning
    Utils.expects(:warning)

    SourceImage.new('img.jpg')
  end

  def test_detect_missing_file
    assert SourceImage.new('img.jpg').missing
  end
end
