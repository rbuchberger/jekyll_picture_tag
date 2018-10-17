# This represents all of the HTML markup that will be returned. Given the high
# level plan, it builds all its own sources (each of which generate their own
# images). It in herits from a generic HTML Double Tag, because that's what it
# is.
class PictureElement < DoubleTag
  require 'objective_elements'
  require_relative 'source'
  def initialize(instructions)
    @instructions = instructions

    super(
      element: 'picture',
      attributes: instructions.attributes[:picture],
      content: content
    )
  end

  def content
    build_sources << build_fallback
  end

  def build_sources
    instructions.preset['sources'].collect do |source|
      Source.new(@instructions, source)
    end
  end

  def build_fallback
    img = SingleTag.new 'img'
    img.add_attributes @instructions.attributes[:img]
    # Include the alt text here
    img.add_attributes alt: @instructions.attributes[:alt]
  end
end
