require 'simplecov'
require 'minitest/rg'

SimpleCov.start do
  add_filter '/test/'
end

require 'minitest/autorun'
require 'mocha/minitest'
require 'pry'
require 'nokogiri'
require 'jekyll_picture_tag'
require_relative 'stubs'

# This module gives us a basic setup to run our tests.
module TestHelper
  TEST_DIR = __dir__
  include Stubs

  def nomarkdown_wrapped?(string)
    # rubocop:disable Style/RegexpLiteral
    start  = /^\{::nomarkdown\}/
    finish = /\{:\/nomarkdown\}$/
    # rubocop:enable Style/RegexpLiteral

    string =~ start &&
      string =~ finish &&
      !string.include?("\n")
  end

  # Checks Nokogiri's html errors. Since it apparently still doesn't know about
  # HTML5, we have to ignore 'invalid tag errors' which have an 801 code (I
  # think):
  def errors_ok?(output)
    output.errors.none? { |e| e.code != 801 }
  end

  def aspect_float(width, height)
    width.to_f / height
  end

  def temp_dir(*descendents)
    @temp_dir ||= Dir.mktmpdir

    File.join(@temp_dir, *descendents)
  end

  # We're having trouble with tests failing because whatever system is running
  # them doesn't support some image format. This returns an array of image
  # formats which we care about, and which are locally supported.
  def supported_formats
    magick_command = command?('magick') ? `magick` : `convert`
    output = `vips --list` + `#{magick_command} --version`

    formats = %w[jpg png webp gif jp2 avif].select do |format|
      output.include? format
    end

    # Sanity check
    raise 'Not enough locally supported formats' unless formats.length >= 3

    formats
  end

  def command?(command)
    is_windows = RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
    if is_windows
      system("where #{command} > NUL 2>&1")
    else
      system("which #{command} > /dev/null 2>&1")
    end
  end
end
