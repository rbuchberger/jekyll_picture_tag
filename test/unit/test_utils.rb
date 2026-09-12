# frozen_string_literal: true

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

  def test_snakeize
    assert_equal 'snake_case', Utils.snakeize('SnakeCase')
  end

  def test_deep_merge_top_level
    default = { 'quality' => 75, 'markup' => 'auto' }
    override = { 'quality' => 30 }

    assert_equal({ 'quality' => 30, 'markup' => 'auto' },
                 Utils.deep_merge(default, override))
  end

  def test_deep_merge_keeps_unset_nested_keys
    default = { 'format_quality' => { 'webp' => 50, 'avif' => 30, 'jp2' => 30 } }
    override = { 'format_quality' => { 'webp' => 60 } }

    assert_equal({ 'format_quality' => { 'webp' => 60,
                                         'avif' => 30,
                                         'jp2' => 30 } },
                 Utils.deep_merge(default, override))
  end

  def test_deep_merge_nested_hashes
    default = { 'image_options' => { 'avif' => { 'speed' => 8,
                                                 'compression' => 'av1' } } }
    override = { 'image_options' => { 'avif' => { 'speed' => 4 } } }

    assert_equal({ 'image_options' => { 'avif' => { 'speed' => 4,
                                                    'compression' => 'av1' } } },
                 Utils.deep_merge(default, override))
  end

  # 'quality' defaults to a number, but may be set to a width => quality graph.
  def test_deep_merge_replaces_mismatched_types
    default = { 'quality' => 75, 'format_quality' => { 'webp' => 50 } }
    override = { 'quality' => { 50 => 50, 100 => 100 }, 'format_quality' => 40 }

    assert_equal({ 'quality' => { 50 => 50, 100 => 100 },
                   'format_quality' => 40 },
                 Utils.deep_merge(default, override))
  end

  # `picture:` with nothing under it parses as nil.
  def test_deep_merge_ignores_empty_overrides
    default = { 'picture' => { 'output' => 'generated' } }

    assert_equal(default, Utils.deep_merge(default, { 'picture' => nil }))
  end

  def test_deep_merge_leaves_default_alone
    default = { 'format_quality' => { 'webp' => 50, 'avif' => 30 } }
    Utils.deep_merge(default, { 'format_quality' => { 'webp' => 60 } })

    assert_equal({ 'format_quality' => { 'webp' => 50, 'avif' => 30 } }, default)
  end
end
