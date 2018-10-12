module PictureTag
  def parse_tag_params
    # Raw argument example example:
    # [preset] img.jpg [source_key: alt-img.jpg] [attr=\"value\"]

    params = liquid_lookup.split

    # The preset is the first parameter, unless it's a filename.
    # This regex is really easy to fool. Will improve later.
    unless params.first =~ /[^\s.]+.\w+/
      @instructions[:preset_name] = params.shift
    end

    # The next parameter will be the image source.
    @instructions[:source_image] = params.shift

    # Check if the next param is a source key, and if so assign it to the
    # local variable source_key.
    while params.first =~ /(?<source_key>\w+):/
      # If there is a source_key, add it as a hash
      params.shift # throw away the param, we already have the key
      @instructions[:alt_source_images] << { source_key => params.shift }
    end

    # Anything left will be html attributes
    @instructions[:html_attributes] = params.shift.join ' '
  end

  def liquid_lookup
    # Render any liquid variables in tag arguments and unescape template code
    Liquid::Template.parse(@raw_params)
                    .render(context)
                    .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
  end
end
