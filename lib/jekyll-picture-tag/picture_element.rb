# This represents all of the HTML markup that will be returned. Given the high
# level plan, it builds all its own sources (each of which generate their own
# images). It in herits from a generic HTML Double Tag, because that's what it
# is.
class PictureElement < DoubleTag
  require 'objective_elements'
  require_relative 'source'
  attr_reader :instructions
  def initialize(instructions)
    @instructions = instructions

    super(
      element: 'picture',
      attributes: instructions.attributes['picture'],
      content: content
    )
  end

  def content
    build_sources << build_fallback
  end

  def build_sources
    instructions.preset['sources'].collect do |source|
      Source.new(instructions, source)
    end
  end

  def build_fallback
    SingleTag.new(
      element: 'img',
      attributes: instructions.attributes['img']
    )
  end
end
