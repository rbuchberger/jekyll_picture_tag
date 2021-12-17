require 'test_helper'
class PresetTest < Minitest::Test
  include PictureTag
  include TestHelper

  def test_merge
    formats = ["jpeg", "webp"]
    original = PictureTag.site.data["picture"]["presets"]["img"]
    PictureTag.site.data["picture"]["presets"]["default"]['formats'] = formats
    preset = Parsers::Preset.new "img"
    assert_equal preset['formats'], formats
    PictureTag.site.data["picture"]["presets"]["default"].each do | key, value|
      if original.has_key?(key)
        assert_equal preset[key], original[key]
      else
        assert_equal preset[key], value
      end
    end
  end

  def test_merge_gem_defaults
    original = PictureTag.site.data["picture"]["presets"]["img"]
    PictureTag.site.data["picture"]["presets"].delete "default"

    preset = Parsers::Preset.new "img"
    assert_equal preset['formats'], ["original"]
    DEFAULT_PRESET.each do | key, value|
      if original.has_key?(key)
        assert_equal preset[key], original[key]
      else
        assert_equal preset[key], value
      end
    end
  end
end
