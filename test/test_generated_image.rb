require 'test_helper'

class GeneratedImageTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @base_name = 'testimage'
    @dest_dir = '/home/loser/generated'
    @digest = 'a' * 6
    @format = 'webp'
    @name = '/home/loser/testimage.jpg'
    @width = 100
  end

  def source_existing
    SourceImageStub.new(base_name: @base_name,
                        name: @name,
                        missing: false,
                        digest: @digest,
                        ext: 'jpg')
  end

  def source_missing
    SourceImageStub.new(base_name: @base_name,
                        name: @name,
                        missing: true,
                        digest: @digest,
                        ext: 'jpg')
  end

  def tested(stub)
    File.stubs(:exist?).returns true
    PictureTag.stubs(:dest_dir).returns(@dest_dir)
    GeneratedImage.any_instance.stubs(:generate_image)
    GeneratedImage.new(source_file: stub,
                       width: 100,
                       format: 'webp')
  end

  # initialize existing source existing dest
  def test_init_with_both
    PictureTag.stubs(:dest_dir).returns(@dest_dir)
    File.stubs(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(true)

    GeneratedImage.any_instance.expects(:generate_image).never
    assert GeneratedImage.new(
      source_file: source_existing, width: 100, format: 'webp'
    )
  end

  # initialize existing source missing dest
  def test_init_missing_dest
    PictureTag.stubs(:dest_dir).returns(@dest_dir)
    File.stubs(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(false)

    GeneratedImage.any_instance.expects(:generate_image)
    assert GeneratedImage.new(
      source_file: source_existing, width: 100, format: 'webp'
    )
  end

  # initialize missing source
  def test_init_missing_source
    PictureTag.stubs(:dest_dir).returns(@dest_dir)
    File.stubs(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(false)

    GeneratedImage.any_instance.expects(:generate_image).never
    assert_silent do
      GeneratedImage.new(source_file: source_missing,
                         width: 100,
                         format: 'webp')
    end
  end

  # test name
  def test_name
    assert_equal 'testimage-100-aaaaaa.webp', tested(source_existing).name
  end

  # absolute filename
  def test_absolute_filename
    assert_equal '/home/loser/generated/testimage-100-aaaaaa.webp',
                 tested(source_existing).absolute_filename
  end

  # test generate image
  # Can't get this one working.
  def test_generate_image
    skip

    dummy_image = Object.new
    dummy_option = Object.new
    PictureTag.stubs(:dest_dir).returns(@dest_dir)

    tested_object = GeneratedImage.new(source_file: source_missing, width: 100,
                                       format: 'webp')

    MiniMagick::Image.stubs(:open).with(@name).returns(dummy_image)

    dummy_image.stubs(:format).with('webp') # << doesn't work.

    dummy_image.stubs(:combine_options).yields(dummy_option)

    dummy_option.expects(:resize).with('100x')
    dummy_option.expects(:auto_orient)
    dummy_option.expects(:strip)

    tested_object.expects(:write_image).with(dummy_image)

    tested_object.send(:generate_image)
  end

  def test_write_image
    dummy = Object.new
    GeneratedImage.any_instance.stubs(:absolute_filename).returns('correct')

    GeneratedImage.any_instance.expects(:check_dest_dir)
    FileUtils.expects(:chmod).with(0o644, 'correct')
    dummy.expects(:write).with('correct')

    GeneratedImage.new(
      source_file: source_missing,
      width: 100,
      format: 'webp'
    ).send(:write_image, dummy)
  end

  # check dest dir exists
  def test_check_dest_dir_existing
    PictureTag.stubs(:dest_dir).returns('/home/loser/generated/')
    Dir.stubs(:exist?).with('/home/loser/generated').returns(true)

    FileUtils.expects(:mkdir_p).never

    tested(source_existing).send(:check_dest_dir)
  end

  # check dest dir missing
  def test_check_dest_dir_missing
    PictureTag.stubs(:dest_dir).returns('/home/loser/generated/')
    Dir.stubs(:exist?).with('/home/loser/generated').returns(false)

    FileUtils.expects(:mkdir_p).with('/home/loser/generated')

    tested(source_existing).send(:check_dest_dir)
  end

  def test_process_format_original
    assert_equal 'jpg',
                 tested(source_existing).send(:process_format, 'original')
  end

  def test_process_format_other
    assert_equal 'webp',
                 tested(source_existing).send(:process_format, 'WEBP')
  end
end
