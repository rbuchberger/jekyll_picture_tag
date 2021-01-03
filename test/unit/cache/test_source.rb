require 'test_helper'

# Source cache and generated cache don't differ in functionality, just
# information format. These unit tests give sufficient coverage for both, as well
# as the Cache::Base module.
class TestCache < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:site).returns(Object.new)
    PictureTag.site.stubs({
                            cache_dir: '/tmp/',
                            config: {}
                          })
  end

  def tested(name = 'img.jpg')
    @tested ||= Cache::Source.new(name)
  end

  def teardown
    FileUtils.rm_rf '/tmp/jpt/'
  end

  def test_initialize_empty
    assert_nil tested[:width]
  end

  def test_data_store
    tested[:width] = 100

    assert tested[:width] = 100
  end

  def test_reject_bad_key
    assert_raises ArgumentError do
      tested[:asdf] = 100
    end
  end

  def test_write_data
    tested[:width] = 100
    tested.write

    assert_path_exists('/tmp/jpt/source/img.jpg.json')
  end

  def test_retrieve_data
    tested[:width] = 100
    tested.write

    assert_equal(100, Cache::Source.new('img.jpg')[:width])
  end

  # Handles filenames with directories in them
  def test_subdirectory_name
    tested('somedir/img.jpg')
    tested[:width] = 100
    tested[:height] = 100
    tested.write

    assert_path_exists('/tmp/jpt/source/somedir/img.jpg.json')
  end
end
