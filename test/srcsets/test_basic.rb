require 'test_helper'

class TestSrcsetBasic < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @source_image = SourceImageStub.new(width: 1000, shortname: 'some name')

    PictureTag.stubs(:source_images).returns(
      'mobile' => @source_image
    )

    @tested = Srcsets::Basic.new(
      media: 'mobile',
      format: 'some format'
    )
  end

  # to_a
  def test_to_a
    @tested.expects(:widths).returns([100])
    @tested.expects(:build_srcset_entry).with(100).returns('correct')
    assert_equal ['correct'], @tested.to_a
  end

  # to_s
  def test_to_s
    @tested.expects(:to_a).returns(%w[correct answer])
    assert_equal 'correct, answer', @tested.to_s
  end

  # mime_type
  def test_mime_type
    MIME::Types.expects(:type_for).with('some format').returns(%i[right wrong])

    assert_equal 'right', @tested.mime_type
  end

  # sizes
  def test_sizes
    refute @tested.sizes
  end

  # check_widths
  def test_check_widths_good
    targets = [100, 200, 400, 800]

    assert_equal targets, @tested.check_widths(targets)
  end

  def test_check_widths_bad
    targets = [100, 200, 400, 8000]
    @tested.expects(:handle_small_source).with(targets, 1000)

    @tested.check_widths(targets)
  end

  # media_attribute
  def test_media_attribute
    PictureTag.expects(:media_presets).returns('mobile' => 'correct')

    assert_equal '(correct)', @tested.media_attribute
  end

  # handle small source
  def test_small_source
    image_width = 1000
    targets = [100, 200, 4000, 8000]
    correct = [100, 200, 1000]

    Utils.expects(:warning)
    assert_equal correct, @tested.send(:handle_small_source, targets,
                                       image_width)
  end

  # generate file
  def test_generate_file
    GeneratedImage.expects(:new).with(
      source_file: @source_image, width: 999, format: 'some format'
    )

    @tested.send(:generate_file, 999)
  end
end
