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
                     gravity: 'center')
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

  def teardown
    FileUtils.rm_r @out_dir if Dir.exist? @out_dir
  end

  def base_image
    @base_image ||= GeneratedImage.new(
      source_file: @test_image, width: 50, format: 'original'
    )
  end

  def tested
    base_image.generate
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
      tested
    end

    assert File.exist? base_image.absolute_filename

    width = MiniMagick::Image.open(base_image.absolute_filename).width

    assert_equal width, 50
  end

  # check dest dir exists
  def test_dest_dir_existing
    skip
    make_dest_dir
    stub_puts

    FileUtils.expects(:mkdir_p).never

    tested
  end

  # check dest dir missing
  def test_dest_dir_missing
    stub_puts

    tested

    assert Dir.exist? @out_dir
  end
end
