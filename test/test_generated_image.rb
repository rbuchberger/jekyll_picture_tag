require 'test_helper'

class GeneratedImageTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @destfile = '/home/loser/generated/img-100-aaaaaa.webp'
    PictureTag.stubs(:dest_dir).returns('/home/loser/generated')
    File.stubs(:exist?).with(@destfile).returns true

    @source_stub = SourceImageStub.new(base_name: 'img',
                                       name: '/home/loser/img.jpg',
                                       missing: false,
                                       digest: 'a' * 6,
                                       ext: 'jpg')
  end

  def tested
    GeneratedImage
      .new(source_file: @source_stub, width: 100, format: 'webp')
  end

  def test_init_existing_dest
    GeneratedImage.any_instance.expects(:generate_image).never

    tested
  end

  def test_init_missing_dest
    File.unstub(:exist?)
    File.stubs(:exist?)
        .with(@destfile)
        .returns(false)

    GeneratedImage.any_instance.expects(:generate_image)

    tested
  end

  def test_name
    assert_equal 'img-100-aaaaaa.webp', tested.name
  end

  # absolute filename
  def test_absolute_filename
    assert_equal '/home/loser/generated/img-100-aaaaaa.webp',
                 tested.absolute_filename
  end

  # test generate image
  # Can't get this one working.
  def test_generate_image
    skip
  end

  # def stub_generate_image
  #   File.stubs(:exist?).with(@destfile).returns(false)
  #
  #   image = Object.new
  #   option = Object.new
  #
  #   MiniMagick::Image.stubs(:open).returns(image)
  #
  #   image.stubs(:combine_options).yields(option)
  #
  #   option.stub_all
  # end

  # check dest dir exists
  def test_dest_dir_existing
    skip
    Dir.stubs(:exist?).with('/home/loser/generated').returns(true)

    FileUtils.expects(:mkdir_p).never

    tested
  end

  # check dest dir missing
  def test_dest_dir_missing
    skip
    Dir.stubs(:exist?).with('/home/loser/generated').returns(false)

    FileUtils.expects(:mkdir_p).with('/home/loser/generated')

    tested
  end

  def test_format
    assert_equal '.webp', File.extname(tested.name)
  end
end
