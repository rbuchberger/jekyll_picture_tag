require_relative './test_integration_helper'

# This class focuses on testing various output formats and their configurations.
class TestIntegrationPresets < Minitest::Test
  include TestIntegrationHelper
  def setup
    base_stubs

    File.stubs(:exist?).returns(true)
  end

  def teardown
    cleanup_files
  end

  # widths 25, 50, 100
  # formats webp, original
  def test_picture_files
    File.unstub(:exist?)
    tested('auto rms.jpg')

    files = rms_file_array(@widths, %w[webp jpg])
    assert(files.all? { |f| File.exist?(f) })
    assert @stdout.include? 'Generating'
  end

  # widths 25, 50, 100
  # formats webp, original
  def test_picture_markup
    output = tested('auto rms.jpg')

    assert errors_ok? output

    sources = output.css('source')
    ss1 = '/generated/rms-25-46a48b.webp 25w,' \
      ' /generated/rms-50-46a48b.webp 50w, /generated/rms-100-46a48b.webp 100w'

    assert_equal ss1, sources[0]['srcset']
    assert_equal std_rms_ss, sources[1]['srcset']

    assert_equal 'image/webp', sources[0]['type']
    assert_equal 'image/jpeg', sources[1]['type']

    assert_equal rms_url, output.at_css('img')['src']
  end

  # multiple source images
  def test_multiple_sources
    output = tested('rms.jpg mobile: spx.jpg')

    assert errors_ok? output

    sources = output.css('source')

    assert_equal std_spx_ss, sources[0]['srcset']
    assert_equal std_rms_ss, sources[1]['srcset']
  end

  # img with sizes attribute
  def test_sizes
    output = tested('sizes rms.jpg')

    assert errors_ok? output

    assert_equal '(max-width: 600px) 80vw, 50%', output.at_css('img')['sizes']
  end

  # pixel ratio sourceset
  def test_pixel_ratio
    output = tested 'pixel_ratio rms.jpg'
    assert errors_ok? output

    correct = '/generated/rms-10-46a48b.jpg 1.0x,'\
      ' /generated/rms-20-46a48b.jpg 2.0x, /generated/rms-30-46a48b.jpg 3.0x'

    assert_equal correct, output.at_css('img')['srcset']
  end

  # attributes from preset
  def test_attributes
    output = tested 'attributes rms.jpg --link example.com'

    assert errors_ok? output

    pic = output.at_css('picture')
    img = output.at_css('img')
    sources = output.css('source')
    anchor = output.at_css('a')

    assert_equal 'parent', pic['class']
    assert_equal '11', pic['data-awesomeness']
    assert_equal 'Alternate Text', img['alt']
    assert_equal 'img', img['class']
    assert_equal 'anchor', anchor['class']
    assert(sources.all? { |s| s['class'] == 'source' })
  end

  # link source
  def test_link_source
    output = tested 'link_source rms.jpg'

    assert errors_ok? output

    assert_equal '/rms.jpg', output.at_css('a')['href']
  end

  # media widths
  def test_media_widths
    output = tested 'media_widths rms.jpg mobile: spx.jpg'
    assert errors_ok? output

    sources = output.css('source')

    ss1 = '/generated/spx-10-2e8bb3.jpg 10w,' \
      ' /generated/spx-20-2e8bb3.jpg 20w, /generated/spx-30-2e8bb3.jpg 30w'

    assert_equal ss1, sources[0]['srcset']
    assert_equal std_rms_ss, sources[1]['srcset']
  end

  # data_auto / data_picture
  def test_data_auto
    output = tested('data_auto rms.jpg')

    assert errors_ok? output

    sources = output.css('source')
    ss1 = '/generated/rms-25-46a48b.webp 25w,' \
      ' /generated/rms-50-46a48b.webp 50w, /generated/rms-100-46a48b.webp 100w'

    assert_equal ss1, sources[0]['data-srcset']
    assert_equal std_rms_ss, sources[1]['data-srcset']

    assert_equal 'image/webp', sources[0]['type']
    assert_equal 'image/jpeg', sources[1]['type']

    assert_equal rms_url, output.at_css('img')['data-src']
  end

  # data_img
  def test_data_img
    output = tested('data_img rms.jpg')
    img = output.at_css('img')

    assert errors_ok? output

    assert_equal std_rms_ss, img['data-srcset']
    assert_equal rms_url, img['data-src']
  end

  # noscript tag
  def test_noscript
    output = tested 'data_noscript rms.jpg'

    noscript = output.at_css('noscript')
    assert_equal rms_url, noscript.children[1]['src']
  end

  # naked_srcset
  def test_naked_srcset
    output = tested_base 'naked_srcset rms.jpg'

    assert_equal std_rms_ss, output
  end

  # direct url
  def test_direct_url
    output = tested_base 'direct_url rms.jpg'

    assert_equal rms_url, output
  end

  # fallback width and format
  def test_fallback
    output = tested 'fallback rms.jpg'
    correct = rms_url(width: 35, format: 'webp')

    assert_equal correct, output.at_css('img')['src']
  end

  # nomarkdown override
  def test_nomarkdown
    output = tested_base 'nomarkdown rms.jpg --link example.com'

    assert nomarkdown_wrapped? output
  end
end
