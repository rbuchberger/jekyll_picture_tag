require 'test_helper'

class TestUtils < Minitest::Test
  include PictureTag

  LiquidTemplate = Struct.new(:render)
  ImageStruct = Struct.new(:width)
  SiteStub = Struct.new(:config)

  # Should strip a trailing slash
  def test_keep_files
    sitestub = SiteStub.new('keep_files' => [])
    PictureTag.stubs(:site).returns(sitestub)
    PictureTag.stubs(:config).returns(
      'picture' => {
        'output' => 'test_output/'
      }
    )

    Utils.keep_files

    assert_includes sitestub.config['keep_files'], 'test_output'
  end

  # test_warning_enabled

  # test_warning_disabled

  # test_liquid_lookup
  def test_liquid_lookup
    template_stub = LiquidTemplate.new

    params = 'params'
    context = 'context'

    Liquid::Template.expects(:parse).with(params).returns(template_stub)
    PictureTag.stubs(:context).returns(context)
    template_stub.expects(:render).with(context)

    Utils.liquid_lookup(params)
  end

  def test_process_format_original
    PictureTag.stubs(:source_images).returns('media' => 'jpg')

    assert_equal Utils.process_format('original', 'media'), 'jpg'
  end

  def test_process_format_other
    assert_equal Utils.process_format('jpg', 'media'), 'jpg'
  end

  # test_count_srcsets
  def test_count_srcsets
    PictureTag.stubs(:preset).returns('formats' => [1, 2, 3, 4])
    PictureTag.stubs(:source_images).returns(a: 'a', b: 'b')

    assert_equal Utils.count_srcsets, 8
  end

  # test_markdown_page?
  def test_markdown_page
    PictureTag.stubs(:page).returns('name' => 'test.md')

    assert Utils.markdown_page?
  end

  # test_not_markdown_page?
  def test_not_markdown_page
    PictureTag.stubs(:page).returns('name' => 'test.html')

    refute Utils.markdown_page?
  end

  # test_biggest_source
  def test_biggest_source
    images = {}

    5.times do |i|
      images[i] = ImageStruct.new(100 + i * 100)
    end

    PictureTag.stubs(:source_images).returns(images)

    assert_equal images[4], Utils.biggest_source
  end

  def test_titleize
    assert_equal Utils.titleize('snake_case'), 'SnakeCase'
  end
end
