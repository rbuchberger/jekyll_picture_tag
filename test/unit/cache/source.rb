require 'test_helper'

# Source cache and generated cache don't differ in functionality, just
# information format. These unit tests give sufficient coverage for both, as well
# as the Cache::Base module.
class TestCache < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:site).returns(build_site_stub)
  end

  def tested(name = 'img.jpg')
    @tested ||= Cache::Source.new(name)
  end

  def teardown
    FileUtils.rm_rf '/tmp/jpt/'
  end

  # Initialize empty
  def test_initialize_empty
    assert_nil tested[:width]
  end

  # Store data
  def test_data_store
    tested[:width] = 100

    assert tested[:width] = 100
  end

  # Reject bad key
  def test_reject_bad_key
    assert_raises ArgumentError do
      tested[:asdf] = 100
    end
  end

  # Write data
  def test_write_data
    tested[:width] = 100
    tested.write

    assert File.exist? '/tmp/jpt/cache/img.jpg.json'
  end

  # Retrieve data
  def test_retrieve_data
    tested[:width] = 100
    tested.write

    assert_equal Cache::Source.new('img.jpg')[:width], 100
  end

  # Handles filenames with directories in them
  def test_subdirectory_name
    tested('somedir/img.jpg.json')
    tested[:width] = 100
    tested[:height] = 100
    tested.write

    assert File.exist? '/tmp/jpt/cache/somedir/img.jpg.json'
  end
end
