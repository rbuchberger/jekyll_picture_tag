module Jekyll

  class Picturefill < Liquid::Tag
    @picture = nil

    def initialize(tag_name, markup, tokens)
      # attributes = ['class', 'src', 'width', 'height', 'title']

      # Regex out arguments
        # image_file
        # array of attributes
        # preset
        # media_key and path to alt sources

      super
    end

    # Get liquidpicturefill obj from _config.yml
    # Grab universal settings, assign to variables
    # Grab default and preset settings, merge into single object

    # Check if generated images exist for specified preset
    # Use preset settings to create images with rmagic

    def render(context)
      if @picture

      # construct and return tag

      else
        "Error processing input, expected syntax: {% picture path/to/img.jpg attribute=\"value\" preset: preset_name media_1: path/to/alt/img.jpg %}"
      end
    end
  end
end

Liquid::Template.register_tag('img', Jekyll::Picturefill)