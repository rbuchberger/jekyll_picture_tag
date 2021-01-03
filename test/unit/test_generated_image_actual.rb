require 'test_helper'

# These tests involve actual image files. That goes a bit beyond a basic unit
# test, but I believe it makes these tests far more valuable, and it's actually
# easier to use real images than to try and stub everything you need to simulate
# them. Since they're tiny, it doesn't add noticable runtime either.
class GeneratedImageActualTest < MiniTest::Test
  include PictureTag
  include TestHelper

  def setup
    GeneratedImage.any_instance.stubs(:puts)
    PictureTag.stubs(config)
  end

  def teardown
    FileUtils.rm_r out_dir if Dir.exist? out_dir
  end

  def tested(basename = 'rms', ext = 'jpg')
    @tested ||= GeneratedImage.new(
      source_file: source_image(basename, ext), width: 50, format: 'original'
    )
  end

  # Actual test image source file
  def source_image(basename, ext)
    @source_image ||= SourceImageStub.new(base_name: basename,
                                          name: File.join(TEST_DIR, "#{basename}.#{ext}"),
                                          missing: false,
                                          digest: 'r' * 6,
                                          ext: ext)
  end

  def config
    {
      dest_dir: out_dir,
      quality: 75,
      fast_build?: false,
      gravity: 'center',
      site: site_stub,
      preset: { 'strip_metadata' => true }
    }
  end

  def out_dir
    '/tmp/jpt'
  end

  def site_stub
    stub = Object.new
    stub.stubs(:cache_dir).returns('cache')

    stub
  end

  def make_dest_dir
    FileUtils.mkdir_p(out_dir)
  end

  def test_generate_image
    make_dest_dir

    assert_output do
      tested.generate
    end

    assert File.exist? tested.absolute_filename

    width = MiniMagick::Image.open(tested.absolute_filename).width

    assert_equal width, 50
  end

  def test_dest_dir_missing
    tested.generate

    assert Dir.exist? out_dir
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

    exif_data = MiniMagick::Image.open(file.absolute_filename)
                                 .data['properties']
                                 .keys
                                 .select { |key| key =~ /^exif:/ }

    assert_empty exif_data
  end
end
