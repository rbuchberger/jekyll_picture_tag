require 'minitest/autorun'
require 'mocha/minitest'
require 'jekyll_picture_tag'

module TestHelper
  LiquidTemplate = Struct.new(:render)
  ImageStruct = Struct.new(:width)
  SiteStub = Struct.new(:config)
  ConfigStub = Struct.new(:source_dir)
end
