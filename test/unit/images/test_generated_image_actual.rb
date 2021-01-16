require 'test_helper'

# These tests involve actual image files. That goes a bit beyond a basic unit
# test, it's actually easier to use real images than to try and stub everything
# you need to simulate them. Since they're tiny, they're fast, too.
class GeneratedImageActualTest < MiniTest::Test
  include PictureTag
  include TestHelper

  # Lifecycle

  def setup
    PictureTag.stubs(config)
    GeneratedImage.any_instance.stubs(:puts)
  end

  def teardown
    FileUtils.rm_r temp_dir if Dir.exist? temp_dir
  end

  # Helpers

  def tested(basename = 'rms', ext = 'jpg')
    @tested ||= GeneratedImage.new(
      source_file: source_image(basename, ext), width: 50, format: 'original'
    )
  end

  def config
    {
      site: site_stub,
      dest_dir: temp_dir,
      quality: 75,
      fast_build?: false,
      gravity: 'center',
      preset: { 'strip_metadata' => true }
    }
  end

  # Actual test image source file
  def source_image(basename, ext)
    SourceImageStub.new(base_name: basename, name: source_name(basename, ext),
                        missing: false, digest: 'r' * 6, ext: ext)
  end

  def source_name(basename, ext)
    File.join(TEST_DIR, 'image_files', "#{basename}.#{ext}")
  end

  def site_stub
    stub = Object.new
    stub.stubs(:cache_dir).returns('cache')

    stub
  end

  # Tests

  def test_generate_image
    tested.generate

    assert_path_exists(tested.absolute_filename)
  end

  def test_generation_message
    assert_output do
      tested.generate
    end
  end

  def test_image_resize
    tested.generate

    width = Vips::Image.new_from_file(tested.absolute_filename).width

    assert_equal(50, width)
  end

  def test_create_dest_dir
    tested.generate

    assert Dir.exist? temp_dir
  end

  def test_update_cache
    Cache::Generated.any_instance.expects(:[]=).with(:width, 100)
    Cache::Generated.any_instance.expects(:[]=).with(:height, 89)
    Cache::Generated.any_instance.expects(:write)

    tested.source_width
  end

  def test_strip_metadata
    # pestka.jpg has exif data.
    file = tested('pestka')
    file.generate

    exif_data = Vips::Image.new_from_file(file.absolute_filename)
                           .get_fields
                           .select { |key| key =~ /^exif:/ }

    assert_empty exif_data
  end

  def test_no_strip_metadata
    skip
    PictureTag.preset['strip_metadata' => false]

    file = tested('pestka')
    file.generate

    exif_data = Vips::Image.new_from_file(file.absolute_filename)
                           .get_fields
                           .select { |key| key =~ /^exif:/ }

    refute_empty exif_data
  end
end
