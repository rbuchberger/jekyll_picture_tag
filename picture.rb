module Jekyll

  class Picture < Liquid::Tag
    @picture = nil

    def initialize(tag_name, markup, tokens)

      # Regex out arguments, add to @picture
        # image_file
        # attributes as single string
        # preset
        # media_keys and path to alt sources

      super
    end

    def render(context)

      # Get liquid_picture obj from _config.yml
      # Grab universal settings, assign to variables

      # run generate_image() for each media_ target

      if @picture

      # construct and return tag

      else
        "Error processing input. Expected syntax: {% picture path/to/img.jpg [attribute=\"value\"] [preset: preset_name] [media_1: path/to/alt/img.jpg] %}"
      end

      def generate_image(img, width, height)

        # get image width, height
        # calculate new img dimensions
        # Check if generated images exist for specified preset
        # Generate missing images with minimagic

        # image destination file name: src_name-WIDTH-HEIGHT.ext
        #                              cat-250-200.jpg

      end
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)