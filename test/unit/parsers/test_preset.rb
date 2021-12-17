require 'test_helper'
class PresetTest < Minitest::Test
  include PictureTag
  include TestHelper
  def setup
    PictureTag.site.data['picture']['presets'] = build_presets
  end
  def test_simple
    original = PictureTag.site.data['picture']['presets']['img']
    assert_nil original['sizes']
    preset = Parsers::Preset.new 'img'
    assert_nil preset['sizes']
  end
  def test_inherit
    original = PictureTag.site.data['picture']['presets']['img']
    expected = PictureTag.site.data['picture']['presets']['sizes']['sizes']
    refute_nil expected
    original['inherit'] = 'sizes'
    preset = Parsers::Preset.new 'img'
    assert_equal preset['sizes'], expected
  end

  def test_inherit_array
    original = PictureTag.site.data['picture']['presets']['img']
    original['inherit'] = ['formats', 'too_large']
    preset = Parsers::Preset.new 'img'
    assert_equal preset['fallback_width'], 800
    assert_equal preset['widths'], [25, 50, 100]
  end
end
