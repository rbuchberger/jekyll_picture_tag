require 'minitest/autorun'
require 'mocha/minitest'
require 'jekyll_picture_tag'

module TestHelper
  ImageStruct = Struct.new(:width)

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
    :name, :width, :uri, keyword_init: true
  )

  SingleTagStub = Struct.new(
    :name, :attributes
  )

  SrcsetStub = Struct.new(
    :sizes, :to_s, :media, :mime_type, :media_attribute
  )
end
