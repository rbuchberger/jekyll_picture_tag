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
                        digest: @digest)
  end

  def source_missing
    SourceImageStub.new(base_name: @base_name,
                        name: @name,
                        missing: true,
                        digest: @digest)
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
    File.expects(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(true)
    PictureTag.expects(:dest_dir).returns(@dest_dir)

    GeneratedImage.new(source_file: source_existing, width: 100, format: 'webp')
  end

  # initialize existing source missing dest
  def test_init_missing_dest
    File.expects(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(false)

    GeneratedImage.any_instance.expects(:generate_image)
    PictureTag.expects(:dest_dir).returns(@dest_dir)

    GeneratedImage.new(source_file: source_existing, width: 100, format: 'webp')
  end

  # initialize missing source
  def test_init_missing_source
    File.expects(:exist?)
        .with(@dest_dir + '/testimage-100-aaaaaa.webp')
        .returns(false)
    PictureTag.expects(:dest_dir).returns(@dest_dir)

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
  # Can't get this one working. Need to figure out how to test block arguments
  def test_generate_image
    skip
    # dummy = Object.new
    #
    # MiniMagick::Image.expects(:open).with(@name).returns(dummy)
    #
    # dummy.expects(:combine_options)
    #
    # dummy.expects(:format).with('webp')
    #
    # GeneratedImage.any_instance.expects(:check_dest_dir)
    # GeneratedImage.any_instance.stubs(:absolute_filename).returns('correct')
    # dummy.expects(:write).with('correct')
    # FileUtils.expects(:chmod).with(0o644, 'correct')
    #
    # GeneratedImage.new(source_file: source_missing, width: 100, format:
    #                    'webp').send(:generate_image)
  end

  # check dest dir exists
  def test_check_dest_dir_existing
    Dir.expects(:exist?)
       .with('/home/loser/generated')
       .returns(true)
    PictureTag.stubs(:dest_dir)
              .returns('/home/loser/generated/')

    GeneratedImage.new(source_file: source_missing, width: 100, format:
                       'webp').send(:check_dest_dir)
  end

  # check dest dir missing
  def test_check_dest_dir_missing
    Dir.expects(:exist?)
       .with('/home/loser/generated')
       .returns(false)
    PictureTag.stubs(:dest_dir)
              .returns('/home/loser/generated/')
    FileUtils.expects(:mkdir_p)
             .with('/home/loser/generated')

    GeneratedImage.new(source_file: source_missing, width: 100, format:
                       'webp').send(:check_dest_dir)
  end
end
