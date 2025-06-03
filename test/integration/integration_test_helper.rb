require 'test_helper'
# Stubs and helpers for end-to-end tests
module IntegrationTestHelper
  include PictureTag
  include TestHelper

  attr_reader :stdout, :stderr

  def setup
    stub_liquid
  end

  # Parsed by Nokogiri, for easier analysis.
  def tested(params = 'rms.jpg')
    Nokogiri::HTML(tested_base(params))
  end

  # Raw output from the tag.
  def tested_base(params = 'rms.jpg')
    output = ''
    @stdout, @stderr = capture_io do
      output = PictureTag::Picture
               .send(:new, 'picture', params, TokenStub.new(true, 'some stub'))
               .render(context)
    end

    output
  end

  def rms_filename(width: 100, format: 'jpg')
    temp_dir(rms_url(width: width, format: format))
  end

  def rms_url(width: 100, format: 'jpg')
    "/generated/rms-#{width}-9f9ef26e5.#{format}"
  end

  def url_matcher(name: 'rms', width: 100, format: 'jpg')
    %r{/generated/#{name}-#{width}-[a-f0-9]{9}.#{format}}
  end

  # Width srcset matcher
  def srcset_matcher_w(name: 'rms', widths: [25, 50, 100], format: 'jpg')
    array = widths.map do |width|
      "/generated\/#{name}-#{width}-[a-f0-9]{9}.#{format} #{width}w"
    end
    Regexp.new(array.join(', '))
  end

  # Pixel ratio srcset matcher
  def srcset_matcher_p(name: 'rms', base: 10, ratios: [1, 2, 3], format: 'jpg')
    array = ratios.map do |ratio|
      "/generated\/#{name}-#{base * ratio}-[a-f0-9]{9}.#{format} #{ratio.to_f}x"
    end
    Regexp.new(array.join(', '))
  end

  def spx_url(width: 100, format: 'jpg')
    "/generated/spx-#{width}-d1ce901d6.#{format}"
  end

  def spx_filename(width: 100, format: 'jpg', crop: '')
    temp_dir(spx_url(width: width, format: format, crop: crop))
  end

  def std_spx_ss
    '/generated/spx-25-d1ce901d6.jpg 25w, ' \
    '/generated/spx-50-d1ce901d6.jpg 50w, ' \
    '/generated/spx-100-d1ce901d6.jpg 100w'
  end

  def std_rms_ss
    '/generated/rms-25-9f9ef26e5.jpg 25w, ' \
    '/generated/rms-50-9f9ef26e5.jpg 50w, ' \
    '/generated/rms-100-9f9ef26e5.jpg 100w'
  end

  def rms_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| rms_filename(width: w, format: f) }
    end

    files.flatten
  end

  def spx_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| spx_filename(width: w, format: f) }
    end

    files.flatten
  end

  def cleanup_files
    FileUtils.rm_rf(temp_dir)
  end
end
