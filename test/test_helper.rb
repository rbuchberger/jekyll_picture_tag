require 'simplecov'

SimpleCov.minimum_coverage_by_file 80
SimpleCov.start do
  add_filter '/test/'
end

require 'minitest/autorun'
require 'mocha/minitest'
require 'pry'
require 'nokogiri'
require 'jekyll_picture_tag'
require_relative 'stubs/jekyll'

# This module gives us a basic setup to run our tests.
module TestHelper
  TEST_DIR = __dir__
  include JekyllStub

  ImageStruct = Struct.new(:width)
  TokenStub = Struct.new(:line_number, :locale)
  ConfigStub = Struct.new(:source_dir)
  SourceImageStub = Struct.new(
    :base_name,
    :name,
    :missing,
    :digest,
    :ext,
    :width,
    :shortname,
    :media_preset,
    keyword_init: true
  )

  GeneratedImageStub = Struct.new(
    :name, :width, :uri, :format, keyword_init: true
  )

  SingleTagStub = Struct.new(
    :name, :attributes
  )

  SrcsetStub = Struct.new(
    :sizes, :to_s, :media, :mime_type, :media_attribute
  )

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
end
