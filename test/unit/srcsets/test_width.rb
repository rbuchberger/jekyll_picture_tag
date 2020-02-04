require_relative 'test_helper_srcsets'

class TestSrcsetWidth < Minitest::Test
  include TestHelperSrcset

  def setup
    build_source_stub
    build_genstubs

    PictureTag.stubs(widths: [100, 200, 300])

    @tested = Srcsets::Width.new(@source_image, 'original')
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

  # basic srcset
  def test_basic
    correct =
      '/img-100-aaaaa.jpg 100w, ' \
      '/img-200-aaaaa.jpg 200w, ' \
      '/img-300-aaaaa.jpg 300w'

    assert_equal correct, @tested.to_s
  end

  def test_image_generation
    PictureTag.stubs(widths: [600])

    stub = gstub(600)

    GeneratedImage.expects(:new)
                  .with(source_file: @source_image, width: 600,
                        format: 'original')
                  .returns(stub)
    stub.expects(:generate)
    @tested.to_s
  end

  # srcset with sizes
  def test_sizes
    stub_picturetag_sizes

    correct = '(mobile query) mobile size, regular size'

    assert_equal correct, @tested.sizes
  end

  # srcset mime type
  def test_mime_type
    assert_equal 'image/jpeg', @tested.mime_type
  end

  # media query name
  def test_media
    assert_equal 'mobile', @tested.media
  end

  # media attribute
  def test_media_attribute
    stub_picturetag_sizes

    assert_equal '(mobile query)', @tested.media_attribute
  end

  # small source
  def test_small_source
    @source_image.width = 150

    correct =
      '/img-100-aaaaa.jpg 100w, ' \
      '/img-150-aaaaa.jpg 150w'

    Utils.expects(:warning)
    assert_equal correct, @tested.to_s
  end

  # Make sure we don't check image width unnecessarily.
  def test_unneeded_widths_check
    @source_image.expects(:width).never
  end
end
