require_relative 'srcsets_test_helper'

class TestSrcsetWidth < Minitest::Test
  include SrcsetTestHelper

  def tested
    Srcsets::Width.new(source_image, 'original')
  end

  def config
    { widths: [100, 200, 300], crop: nil, gravity: 'center' }
  end

  def stub_picturetag_sizes
    PictureTag.stubs(preset: {
                       'sizes' => { 'mobile' => 'mobile size' },
                       'size' => 'regular size'
                     },
                     media_presets: {
                       'mobile' => 'mobile query'
                     })
  end

  def test_basic
    correct =
      '/img-100-aaaaa.jpg 100w, ' \
      '/img-200-aaaaa.jpg 200w, ' \
      '/img-300-aaaaa.jpg 300w'

    assert_equal correct, tested.to_s
  end

  def test_image_generation
    PictureTag.stubs(widths: [600])
    stub_generated(600, stub = gstub(600))

    stub.expects(:generate)

    tested.to_s
  end

  def test_sizes
    stub_picturetag_sizes

    correct = '(mobile query) mobile size, regular size'

    assert_equal correct, tested.sizes
  end

  def test_mime_type
    assert_equal 'image/jpeg', tested.mime_type
  end

  def test_media
    assert_equal 'mobile', tested.media
  end

  def test_media_attribute
    stub_picturetag_sizes

    assert_equal '(mobile query)', tested.media_attribute
  end

  def test_small_source
    source_image.width = 150

    correct =
      '/img-100-aaaaa.jpg 100w, ' \
      '/img-150-aaaaa.jpg 150w'

    Utils.expects(:warning)
    assert_equal correct, tested.to_s
  end

  # Make sure we don't check image width unnecessarily.
  def test_unneeded_widths_check
    GeneratedImage.unstub(:new)
    GeneratedImage.stubs(new: gstub(600, exists: true))
    source_image.expects(:width).never

    tested.to_s
  end
end
