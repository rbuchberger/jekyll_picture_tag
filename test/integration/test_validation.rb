# Input validation tests
class TestIntegrationValidation < Minitest::Test
  include IntegrationTestHelper

  # Lifecycle

  def teardown
    cleanup_files
  end

  # Helpers

  def assert_arg_error(*args)
    assert_raises(ArgumentError) { tested(*args) }
  end

  # Preset tests

  def test_markup_not_a_format
    presets['default']['markup'] = 'not_a_markup_format'

    assert_arg_error
  end

  def test_markup_not_a_string
    presets['default']['markup'] = 42

    assert_arg_error
  end

  def test_markup_has_spaces
    presets['default']['markup'] = 'not a markup format'

    assert_arg_error
  end

  def test_image_formats
    presets['default']['formats'] = %w[not real image formats]

    assert_arg_error
  end

  # Setting expects an array, but it should still work if given a simple string.
  def test_image_format_coercion
    presets['default']['formats'] = 'webp'

    assert_includes tested.css('img').first['srcset'], '.webp'
  end

  def test_width_validation
    presets['default']['widths'] = %w[words aren't numbers]

    assert_arg_error
  end

  def test_width_hash_check
    presets['default']['media_widths'] =
      { 'mobile' => %w[words aren't numbers] }

    assert_arg_error('rms.jpg mobile: spx.jpg')
  end
  # fallback format validation

  def test_fallback_width_bad_chars
    presets['default']['fallback_width'] = 'abc123'

    assert_arg_error
  end

  def test_fallback_width_bad_type
    presets['default']['fallback_width'] = '1.000'

    assert_arg_error
  end

  # nomarkdown
  def test_nomarkdown_bad_arg
    presets['default']['nomarkdown'] = 'yes'

    assert_arg_error('rms.jpg --link homestarrunner.com')
  end
end
