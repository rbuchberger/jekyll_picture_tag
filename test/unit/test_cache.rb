require 'test_helper'

class TestCache < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(site: Object.new)
    PictureTag.site.stubs(cache_dir: temp_dir, config: {})
  end

  def tested(name = 'img.jpg')
    @tested ||= Cache.new(name)
  end

  def teardown
    FileUtils.rm_rf temp_dir
  end

  def test_initialize_empty
    assert_nil tested[:digest]
  end

  def test_data_store
    tested[:digest] = 'scruffer pupper'

    assert tested[:digest] = 'scruffer pupper'
  end

  def test_reject_bad_key
    assert_raises ArgumentError do
      tested[:asdf] = 100
    end
  end

  def test_write_data
    tested[:digest] = 'scruffer pupper'
    tested.write

    assert_path_exists temp_dir('jpt', 'img.jpg.json')
  end

  def test_retrieve_data
    tested[:digest] = 'scruffer pupper'
    tested.write

    assert_equal 'scruffer pupper', Cache.new('img.jpg')[:digest]
  end

  # Handles filenames with directories in them
  def test_subdirectory_name
    tested(File.join('somedir', 'img.jpg'))
    tested[:digest] = 'abc123'
    tested.write

    assert_path_exists temp_dir('jpt', 'somedir', 'img.jpg.json')
  end

  # Jekyll has a flag to disable caching; we must respect it.
  def test_disable_disk_cache
    PictureTag.stubs(config: { 'disable_disk_cache' => true })

    tested[:digest] = 'asdf'
    tested.write

    refute_path_exists temp_dir('img.jpg.json')
  end
end
