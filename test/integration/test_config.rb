require_relative './test_integration_helper'
class TestIntegrationConfig < Minitest::Test
  include TestIntegrationHelper

  def setup
    base_stubs
  end

  def teardown
    cleanup_files
  end

  def test_nomarkdown_autodetect
    @page['ext'] = '.md'
    output = tested_base 'rms.jpg --link example.com'

    assert nomarkdown_wrapped? output
  end

  def test_nomarkdown_disable
    @pconfig['nomarkdown'] = false
    @page['ext'] = '.md'
    output = tested_base 'rms.jpg --link example.com'

    refute nomarkdown_wrapped? output
  end

  def test_warning
    tested 'too_large rms.jpg'

    assert_includes @stderr, 'rms.jpg'
  end

  # suppress warnings
  def test_suppress_warnings
    @pconfig['suppress_warnings'] = true
    tested 'too_large rms.jpg'

    assert_empty @stderr
  end

  # continue on missing
  def test_missing_source
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = true

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-e555e4f8b.jpg 25w,' \
      ' /generated/asdf-50-e555e4f8b.jpg 50w, /generated/asdf-100-e555e4f8b.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert_includes @stderr, 'asdf.jpg'
  end

  def test_missing_source_array
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = %w[development testing]

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-e555e4f8b.jpg 25w,' \
      ' /generated/asdf-50-e555e4f8b.jpg 50w, /generated/asdf-100-e555e4f8b.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert_includes @stderr, 'asdf.jpg'
  end

  def test_missing_source_string
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = 'development'

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-e555e4f8b.jpg 25w,' \
      ' /generated/asdf-50-e555e4f8b.jpg 50w, /generated/asdf-100-e555e4f8b.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert_includes @stderr, 'asdf.jpg'
  end

  def test_missing_source_nocontinue
    File.unstub(:exist?)

    assert_raises do
      tested 'asdf.jpg'
    end
  end

  def test_absolute_urls
    @pconfig['relative_url'] = false

    ss = 'example.com/generated/rms-25-9ffc043fa.jpg 25w,' \
      ' example.com/generated/rms-50-9ffc043fa.jpg 50w,' \
      ' example.com/generated/rms-100-9ffc043fa.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  def test_baseurl
    @jconfig['baseurl'] = 'blog'

    ss = '/blog/generated/rms-25-9ffc043fa.jpg 25w, ' \
    '/blog/generated/rms-50-9ffc043fa.jpg 50w,' \
    ' /blog/generated/rms-100-9ffc043fa.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # cdn url
  def test_cdn
    @context.environments = [{ 'jekyll' => { 'environment' => 'production' } }]
    @pconfig['cdn_url'] = 'cdn.net'
    ss = 'cdn.net/generated/rms-25-9ffc043fa.jpg 25w,' \
      ' cdn.net/generated/rms-50-9ffc043fa.jpg 50w,' \
      ' cdn.net/generated/rms-100-9ffc043fa.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # cdn environments
  def test_cdn_env
    @pconfig['cdn_url'] = 'cdn.net'
    @pconfig['cdn_environments'] = ['development']
    ss = 'cdn.net/generated/rms-25-9ffc043fa.jpg 25w,' \
      ' cdn.net/generated/rms-50-9ffc043fa.jpg 50w,' \
      ' cdn.net/generated/rms-100-9ffc043fa.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # preset not found warning
  def test_missing_preset
    tested('asdf rms.jpg')

    assert_includes @stderr, 'asdf'
  end

  # small src (fallback)
  # small source in srcset
  def test_small_source
    output = tested 'too_large rms.jpg'
    src = '/generated/rms-100-9ffc043fa.jpg'
    ss = '/generated/rms-100-9ffc043fa.jpg 100w'

    assert_includes @stderr, 'rms.jpg'
    assert_equal src, output.at_css('img')['src']
    assert_equal ss, output.at_css('img')['srcset']
  end

  def test_disabled
    @pconfig['disabled'] = ['development']

    assert_equal tested_base, ''
  end

  def test_fast_build
    File.unstub(:exist?)
    @pconfig['fast_build'] = true

    tested 'rms.jpg' # Call once to ensure files and caches exist

    PictureTag::SourceImage.any_instance.expects(:source_digest).never

    tested 'rms.jpg'
  end
end
