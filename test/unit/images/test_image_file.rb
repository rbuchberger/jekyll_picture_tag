# Tests of Image Files
class TestImageFile < Minitest::Test
  include PictureTag
  include TestHelper

  # Lifecycle

  def setup
    PictureTag.stubs(preset: preset)
    ImageFile.any_instance.stubs(:puts)
  end

  def preset
    {
      'strip_metadata' => true,
      'image_options' => {
        'avif' => { 'compression' => 'av1' }
      }
    }
  end

  def teardown
    FileUtils.rm_r temp_dir if Dir.exist? temp_dir
  end

  # Helpers

  def tested
    ImageFile.new(source_stub, gen_stub)
  end

  def dest_name
    @dest_name ||= 'tested.jpg'
  end

  def format
    @format ||= 'jpg'
  end

  def filename
    temp_dir(dest_name)
  end

  def gen_config
    {
      width: 10,
      format: format,
      crop: nil,
      keep: nil,
      quality: 75,
      absolute_filename: filename,
      name: dest_name
    }
  end

  def source_config(*args)
    {
      name: source_filename(*args),
      crop?: false,
      width: source_image.width,
      height: source_image.height
    }
  end

  def source_image
    Vips::Image.new_from_file(source_filename)
  end

  def source_filename(basename = 'rms', format = 'jpg')
    File.join(TEST_DIR, 'image_files', "#{basename}.#{format}")
  end

  def gen_stub
    @gen_stub ||= build_stub(gen_config)
  end

  def source_stub
    @source_stub ||= build_stub(source_config)
  end

  def build_stub(config)
    Struct.new(*config.keys).new(*config.values)
  end

  def restub(new_name)
    @dest_name = new_name
    @format = new_name.split('.').last
    @gen_stub = build_stub(gen_config)
  end

  def restub_source(*args)
    @source_stub = build_stub source_config(*args)
  end

  # Tests

  # crop
  # autorotate

  # Verify we can convert to and from all the formats we care about
  def test_format_conversions
    formats = supported_formats

    formats.each do |input_format|
      restub_source('rms', input_format)

      formats.each do |output_format|
        restub('rms.' + output_format)

        tested

        assert_path_exists filename
        FileUtils.rm filename
      end
    end
  end

  def test_notification
    ImageFile.any_instance.unstub(:puts)
    assert_output { tested }
  end

  def test_resize
    restub 'resize.jpg'
    tested

    width = Vips::Image.new_from_file(filename).width

    assert_equal(10, width)
  end

  def test_resize_with_alpha
    restub_source('pestka_transparent', 'png')
    tested

    width = Vips::Image.new_from_file(filename).width

    assert_equal(10, width)
  end

  def test_quality
    # We have to use slightly larger images for the quality to make a difference
    # in file size.
    restub 'hq.jpg'
    gen_stub.stubs(width: 75)
    tested

    hq_size = File.size filename

    restub 'lq.jpg'
    gen_stub.stubs(quality: 10)

    tested

    lq_size = File.size filename

    # The low quality image should be much smaller than the high quality image.
    assert (lq_size.to_f / hq_size) < 0.5
  end

  def test_strip_metadata
    restub 'strip.jpg'
    source_stub.stubs(name: source_filename('pestka'))

    tested

    exif_data = Vips::Image.new_from_file(filename)
                           .get_fields
                           .select { |key| key =~ /^exif/ }

    assert_empty exif_data
  end

  def test_no_strip_metadata
    source_stub.stubs(name: source_filename('pestka'))
    restub 'nostrip.jpg'
    PictureTag.preset['strip_metadata'] = false

    tested

    exif_data = Vips::Image.new_from_file(filename)
                           .get_fields
                           .select { |key| key =~ /^exif/ }

    refute_empty exif_data
  end

  def test_dest_dir
    tested

    assert_path_exists temp_dir
  end
end
