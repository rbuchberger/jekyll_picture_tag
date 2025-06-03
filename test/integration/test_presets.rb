require_relative 'integration_test_helper'
require 'vips'

# This class focuses on testing various output formats and their configurations.
# The preset names are defined in test/stubs/jekyll.rb
class TestIntegrationPresets < Minitest::Test
  include IntegrationTestHelper
  include Vips

  def teardown
    cleanup_files
  end

  # widths 25, 50, 100
  # formats webp, original
  def test_picture_files
    tested('auto rms.jpg')
    files = Dir.glob(temp_dir('generated', '*'))

    assert_equal(6, files.length)
    assert_includes stdout, 'Generating'
  end

  # widths 25, 50, 100
  # formats webp, original
  def test_picture_markup
    output = tested('auto rms.jpg')

    assert errors_ok? output

    sources = output.css('source')
    ss1 = '/generated/rms-25-c87b11253.webp 25w,' \
      ' /generated/rms-50-c87b11253.webp 50w,' \
      ' /generated/rms-100-c87b11253.webp 100w'

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

  # Pixel ratio srcset
  def test_pixel_ratio
    output = tested 'pixel_ratio rms.jpg'

    # correct = '/generated/rms-10-c87b11253.jpg 1.0x,'\
    #   ' /generated/rms-20-c87b11253.jpg 2.0x,' \
    #   ' /generated/rms-30-c87b11253.jpg 3.0x'

    assert_match srcset_matcher_p, output.at_css('img')['srcset']
  end

  # data_ output with sizes attr, yes data-sizes
  def test_data_img_yes_size
    output = tested('data_img_yes_size rms.jpg')

    assert errors_ok? output

    assert_equal '(max-width: 600px) 80vw, 50%',
                 output.at_css('img')['data-sizes']
  end

  # data_ output with sizes attr, no data-sizes
  def test_data_img_no_size
    output = tested('data_img_no_size rms.jpg')

    assert errors_ok? output

    assert_equal '(max-width: 600px) 80vw, 50%',
                 output.at_css('img')['sizes']
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

  # Ensure that attributes passed into the tag do not persist to other tags.
  def test_attribute_persistence
    tested 'attributes rms.jpg --img class="goaway"'

    test_attributes
  end

  # Ensure that when attributes are passed from both the argument and the
  # preset, they all make it into the final output.
  def test_combined_attributes
    output = tested 'attributes rms.jpg --img class="arg classes"'
    attrs = output.at_css('img')['class'].split

    assert_includes attrs, 'arg'
    assert_includes attrs, 'classes'
    assert_includes attrs, 'img'
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

    ss1 = '/generated/spx-10-d1ce901d6.jpg 10w,' \
      ' /generated/spx-20-d1ce901d6.jpg 20w,' \
      ' /generated/spx-30-d1ce901d6.jpg 30w'

    assert_equal ss1, sources[0]['srcset']
    assert_equal std_rms_ss, sources[1]['srcset']
  end

  # data_auto / data_picture
  def test_data_auto
    output = tested('data_auto rms.jpg')

    assert errors_ok? output

    sources = output.css('source')

    assert_match srcset_matcher_w(format: 'webp'), sources[0]['data-srcset']
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

    assert_match url_matcher(format: 'webp', width: 35),
                 output.at_css('img')['src']
  end

  # Fallback is actually generated
  def test_fallback_exists
    File.unstub :exist?
    tested 'fallback rms.jpg'

    files = Dir.glob(temp_dir('generated', 'rms-35-?????????.webp'))

    assert_equal 1, files.length
  end

  # Ensure fallback images aren't enlarged when cropped.
  def test_cropped_fallback
    output = tested 'fallback rms.jpg 1:3'

    assert_includes stderr, 'rms.jpg'
    assert_match url_matcher(format: 'webp', width: 30),
                 output.at_css('img')['src']
  end

  # nomarkdown override
  def test_nomarkdown
    output = tested_base 'nomarkdown rms.jpg --link example.com'

    assert nomarkdown_wrapped? output
  end

  # convert from each to each, make sure nothing breaks.
  def test_conversions
    File.unstub(:exist?)
    formats = supported_formats
    presets['formats']['formats'] = formats

    formats.each do |input_format|
      output = tested "formats rms.#{input_format}"

      sources = output.css('source')
      formats.each do |output_format|
        mime = MIME::Types.type_for(output_format).first.to_s
        assert(sources.any? { |source| source['type'] == mime },
               "Failed to generate a source with type #{mime}")
      end
    end

    files = Dir.entries(temp_dir('generated'))

    formats.each do |format|
      assert_equal(
        formats.length, files.count { |f| File.extname(f) == '.' + format }
      )
    end
  end

  def test_crop
    # Crop preset should crop desktop to 3:2 and mobile to 16:9. Test images are
    # around 1:1 (but not exactly)
    tested 'crop rms.jpg mobile: spx.jpg'

    rms_dimensions =
      Image.new_from_file(temp_dir('generated', 'rms-100-ced21b33d.jpg')).size

    spx_dimensions =
      Image.new_from_file(temp_dir('generated', 'spx-100-63d4bc0d5.jpg')).size

    assert_in_delta aspect_float(3, 2), aspect_float(*rms_dimensions), 0.03
    assert_in_delta aspect_float(16, 9), aspect_float(*spx_dimensions), 0.03
  end

  def test_dimension_attributes_basic
    output = tested 'dimension_attributes rms.jpg'

    assert_equal '100', output.at_css('img')['width']
    assert_equal '89', output.at_css('img')['height']
  end

  def test_dimension_attributes_cropped
    output = tested 'dimension_attributes rms.jpg 2:1'

    assert_equal '100', output.at_css('img')['width']
    assert_equal '50', output.at_css('img')['height']
  end

  def test_dimension_attributes_multiformat
    output = tested 'dimension_attributes_multiformat rms.jpg'

    assert_equal '100', output.at_css('img')['width']
    assert_equal '89', output.at_css('img')['height']
  end

  # If width and height are set in the preset, they should be overridden rather
  # than appended.
  def test_dimension_attributes_replace_values
    output = tested 'dimension_attributes_replace_values rms.jpg'

    assert_equal '100', output.at_css('img')['width']
    assert_equal '89', output.at_css('img')['height']
  end

  # We don't have an easy way to verify output image quality; the best we can do
  # is make sure you don't get any errors when running it.
  def test_calculated_quality
    assert_silent do
      tested 'calculated_quality rms.jpg'
    end
  end

  def test_calculated_quality_reverse
    assert_silent do
      tested 'calculated_quality_reverse rms.jpg'
    end
  end
end
