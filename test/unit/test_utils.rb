require 'test_helper'

class TestUtils < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(site: Object.new, pconfig: {}, page: {})
    PictureTag.site.stubs(config: {})
  end

  def test_keep_files
    PictureTag.pconfig['output'] = 'test_output/'
    PictureTag.site.config['keep_files'] = []

    Utils.keep_files

    # Should strip a trailing slash if present.
    assert_includes PictureTag.site.config['keep_files'], 'test_output'
  end

  def test_warning_enabled
    PictureTag.pconfig['suppress_warnings'] = false

    assert_output nil, /test message/ do
      Utils.warning('test message')
    end
  end

  def test_warning_disabled
    PictureTag.pconfig['suppress_warnings'] = true

    assert_silent do
      Utils.warning('test message')
    end
  end

  def test_liquid_lookup
    PictureTag.stubs(context: 'context')
    Liquid::Template.stubs(:parse).with('params')
                    .returns(template_stub = Object.new)

    template_stub.expects(:render).with('context')

    Utils.liquid_lookup('params')
  end

  def test_count_srcsets
    PictureTag.stubs(formats: [1, 2, 3, 4], source_images: { a: 'a', b: 'b' })

    assert_equal(8, Utils.count_srcsets)
  end

  def test_markdown_page
    PictureTag.page['name'] = 'test.md'

    assert Utils.markdown_page?
  end

  def test_not_markdown_page
    PictureTag.page['name'] = 'test.html'

    refute Utils.markdown_page?
  end

  def test_titleize
    assert_equal 'SnakeCase', Utils.titleize('snake_case')
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
