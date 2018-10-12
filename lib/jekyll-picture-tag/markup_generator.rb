module PictureTag
  def build_source_tag(source_name, attributes, instructions = {})
    srcset = build_ppi_srcset(source_name, attributes)
    tag = SingleTag.new 'source'
    tag.add_attributes media: attributes[:media], srcset: srcset
    tag.add_attributes instructions['source_attributes']
    tag
  end


  def build_fallback_image
    img = SingleTag.new 'img'
    img.add_attributes instructions['img_properties']
    img.add_attributes alt: instructions['alt'] if instructions['alt']
    # TODO: implement default image
    img.add_attributes src: '#'
  end

  def build_picture_tag(sources, instructions)
    picture = DoubleTag.new 'picture'
    picture.add_attributes instructions['picture_attributes']
    sources.each_pair do |source, properties|
      picture.add_content build_source_tag(source, properties, instructions)
    end

    picture.add_content build_fallback_image
  end
end
