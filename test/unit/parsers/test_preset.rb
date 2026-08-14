# frozen_string_literal: true

require 'test_helper'

class TestPreset < Minitest::Test
  include PictureTag

  def setup
    PictureTag.stubs(site: Object.new, config: { 'data_dir' => '_data' })
  end

  def stub_preset(settings)
    PictureTag.site.stubs(data: { 'picture' => { 'presets' => { 'logo' => settings } } })
  end

  def tested
    Parsers::Preset.new('logo')
  end

  def test_default_values
    stub_preset({})

    assert_equal 'auto', tested['markup']
    assert_equal 75, tested['quality']
  end

  def test_overrides_default_values
    stub_preset('quality' => 30)

    assert_equal 30, tested['quality']
  end

  # Setting one format's quality must not discard the others.
  def test_deep_merges_nested_settings
    stub_preset('format_quality' => { 'webp' => 60 })

    assert_equal({ 'webp' => 60, 'avif' => 30, 'jp2' => 30 },
                 tested['format_quality'])
  end

  def test_leaves_default_preset_alone
    stub_preset('format_quality' => { 'webp' => 60 })
    tested['format_quality']

    assert_equal({ 'webp' => 50, 'avif' => 30, 'jp2' => 30 },
                 DEFAULT_PRESET['format_quality'])
  end

  # Stock presets are merged over the defaults just like user-defined ones.
  def test_stock_presets_get_defaults
    PictureTag.stubs(site: Object.new)
    PictureTag.site.stubs(data: {})

    assert_equal({ 'webp' => 50, 'avif' => 30, 'jp2' => 30 },
                 Parsers::Preset.new('jpt-avif')['format_quality'])
  end
end
