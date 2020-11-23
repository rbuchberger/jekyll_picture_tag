require 'test_helper'

class TestUtils < Minitest::Test
  include PictureTag
  include TestHelper

  # Should strip a trailing slash
  def test_keep_files
    sitestub = Object.new
    sitestub.stubs(:config).returns('keep_files' => [])
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
  def test_warning_enabled
    PictureTag
      .stubs(:config).returns('picture' => { 'suppress_warnings' => false })

    # First arg is stdout, second is a regex matching stderr
    assert_output nil, /test message/ do
      Utils.warning('test message')
    end
  end

  # test_warning_disabled
  def test_warning_disabled
    PictureTag
      .stubs(:config).returns('picture' => { 'suppress_warnings' => true })

    assert_silent do
      Utils.warning('test message')
    end
  end

  # test_liquid_lookup
  def test_liquid_lookup
    template_stub = Object.new
    PictureTag.stubs(:context).returns('context')

    Liquid::Template.stubs(:parse).with('params').returns(template_stub)
    template_stub.expects(:render).with('context')

    Utils.liquid_lookup('params')
  end

  # test_count_srcsets
  def test_count_srcsets
    PictureTag.stubs(:formats).returns([1, 2, 3, 4])
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

  def test_titleize
    assert_equal Utils.titleize('snake_case'), 'SnakeCase'
  end

  # Had to bust out my old TI-86 to work this one out!
  def test_interpolate
    xvals = [10, 30]
    yvals = [25, 35]

    assert_in_delta 43.5, Utils.interpolate(xvals, yvals, 47), 0.01
    assert_in_delta 26.5, Utils.interpolate(xvals, yvals, 13), 0.01
    assert_in_delta 70, Utils.interpolate(xvals, yvals, 100), 0.01
  end
end
