# This represents all of the HTML markup that will be returned. Given the high
# level plan, it builds all its own sources (each of which generate their own
# images).
class PictureElement
  def initialize(instructions)
    @instructions = instructions
  end

  def markup
    if @instructions.preset['format'].length > 1 ||
       @instructions.source_images.length > 1
      build_picture_tag
    else
      build_image_tag
    end
  end

  def content
    build_sources << build_fallback
    instructions.preset['format'].length > 1
  end

  def build_picture_tag
    DoubleTag.new(
      element: 'picture',
      attributes: instructions.attributes[:picture],
      content: build_sources
    )
  end

  def build_sources
    @instructions.source_images.each do 
      @instructions.preset.format.each do

      end
    end
  end

  def build_source(source_image, sizes, formats)

  end

  def build_fallback
    img = SingleTag.new 'img'
    img.add_attributes @instructions.attributes[:img]
    img.add_attributes alt: @instructions.attributes[:alt]
  end
end
