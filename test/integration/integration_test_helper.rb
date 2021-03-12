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
    File.join temp_dir, rms_url(width: width, format: format)
  end

  def rms_url(width: 100, format: 'jpg')
    "/generated/rms-#{width}-9f9ef26e5.#{format}"
  end

  def spx_url(width: 100, format: 'jpg')
    "/generated/spx-#{width}-d1ce901d6.#{format}"
  end

  def spx_filename(width: 100, format: 'jpg', crop: '')
    File.join temp_dir, spx_url(width: width, format: format, crop: crop)
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
