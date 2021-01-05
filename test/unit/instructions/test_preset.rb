require 'test_helper'
class PresetTest < Minitest::Test
  include PictureTag
  include TestHelper
  include JekyllStub
  # Honestly, this one is more a test of my stubs than a test of the logic.
  # The preset stubs can be found in test/stubs/jekyll.rb

  def setup
    build_defaults
    build_site_stub
    build_context_stub
  end

  def tested(name = 'default')
    PictureTag.stubs(:context).returns(@context)
    PictureTag.stubs(:site).returns(@site)

    PictureTag::Instructions::Preset.new(name)
  end

  # widths with media
  def test_media_widths
    assert_equal [10, 20, 30], tested('media_widths').widths('mobile')
  end

  # widths without media
  def test_widths
    assert_equal [400, 600, 800], tested('too_large').widths('mobile')
  end

  # formats
  def test_formats
    assert_equal %w[jpg jp2 png webp gif], tested('formats').formats
  end

  # fallback format
  def test_fallback_format
    assert_equal 'original', tested.fallback_format
  end

  # fallback width
  def test_fallback_width
    assert_equal 800, tested.fallback_width
  end

  # nomarkdown set
  def test_nomarkdown_set
    assert tested('nomarkdown').nomarkdown?
  end

  # nomarkdown unset
  def test_nomarkdown_unset
    config_stub = Object.new
    config_stub.stubs(:nomarkdown?).returns(false)
    PictureTag.stubs(:config).returns(config_stub)

    refute tested.nomarkdown?
  end

  # quality default
  def test_quality_global_constant
    assert_equal 30, tested('quality').quality('jpg')
  end

  def test_quality_media_constant
    assert_equal 45, tested('quality').quality('webp')
  end

  def test_quality_calculated
    results = [25, 50, 75, 100, 150].map do |value|
      tested('calculated_quality').quality(nil, value)
    end

    assert_equal [50, 50, 75, 100, 100], results
  end

  # Order should not matter.
  def test_quality_calculated_reverse
    results = [25, 50, 75, 100, 150].map do |value|
      tested('calculated_quality_reverse').quality(nil, value)
    end

    assert_equal [50, 50, 75, 100, 100], results
  end

  def test_missing_preset
    config_stub = Object.new
    config_stub.stubs(:[]).returns('data_dir')
    PictureTag.stubs(:config).returns(config_stub)

    Utils.expects(:warning)

    tested('asdf')
  end

  def test_crop
    assert_equal '3:2', tested('crop').crop
  end

  def test_crop_default
    assert_equal '3:2', tested('crop').crop('desktop')
  end

  def test_media_crop
    assert_equal '16:9', tested('crop').crop('mobile')
  end

  def test_gravity
    assert_equal 'north', tested('crop').gravity
  end

  def test_gravity_default
    assert_equal 'north', tested('crop').gravity('desktop')
  end

  def test_media_gravity
    assert_equal 'northwest', tested('crop').gravity('mobile')
  end
end
