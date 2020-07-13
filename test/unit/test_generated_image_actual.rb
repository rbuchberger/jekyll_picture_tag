require 'test_helper'

# These tests involve actual image files. That goes a bit beyond a basic unit
# test, but I believe it makes these tests far more valuable, and it's actually
# easier to use real images than to try and stub everything you need to simulate
# them. Since they're tiny, it doesn't add noticable runtime either.
class GeneratedImageActualTest < MiniTest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(dest_dir: '/tmp/jpt', quality: 75, fast_build?: false,
                     gravity: 'center', site: site_stub)
    @out_file = 'rms-50-21053d7bb.jpg'
    @out_dir = '/tmp/jpt'

    # Actual test image file
    @test_image = SourceImageStub.new(base_name: 'rms',
                                      name: File.join(TEST_DIR, 'rms.jpg'),
                                      missing: false,
                                      digest: 'r' * 6,
                                      ext: 'jpg')

    FileUtils.rm @out_file if File.exist? @out_file
  end

  def site_stub
    stub = Object.new
    stub.stubs(:cache_dir).returns('cache')

    stub
  end

  def teardown
    FileUtils.rm_r @out_dir if Dir.exist? @out_dir
  end

  def tested
    @tested ||= GeneratedImage.new(
      source_file: @test_image, width: 50, format: 'original'
    )
  end

  def make_dest_dir
    FileUtils.mkdir_p(@out_dir)
  end

  def stub_puts
    GeneratedImage.any_instance.stubs(:puts)
  end

  # test generate image
  def test_generate_image
    make_dest_dir

    assert_output do
      tested.generate
    end

    assert File.exist? tested.absolute_filename

    width = MiniMagick::Image.open(tested.absolute_filename).width

    assert_equal width, 50
  end

  # check dest dir missing
  def test_dest_dir_missing
    stub_puts

    tested.generate

    assert Dir.exist? @out_dir
  end

  def test_update_cache
    Cache::Generated.any_instance.expects(:[]=).with(:width, 100)
    Cache::Generated.any_instance.expects(:[]=).with(:height, 89)
    Cache::Generated.any_instance.expects(:write)

    tested.source_width
  end
end
