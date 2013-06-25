module Jekyll

  class Picture < Liquid::Tag
    @picture = nil

    def initialize(tag_name, markup, tokens)

      # if picture arguments are correct

      # Regex out arguments
      @markup = regex here

      @image_src  = regex part
      @attributes = regex part
      # need to regex out alt value and then remove alt key and value from @attributes string
        @alt      = regex part
      @preset     = regex part
      @media_src  = regex part

      super
    end

    def render(context)

      # Get liquid_picture obj from _config.yml
      # @settings
      # @settings[src_dir]
      # @settings[dest_dir]

      # create sources array to be rendered into html
      # @sources = []

      # @preset = @settings[presets][@preset]

      # each {| media_key, settings |

        # settings[media]
        # settings[width]
        # settings[height]

        # create generated img paths
        # run generate_image() for each media_ target

        # @sources[media_key][img_path]
        # @sources[media_key][media]

      if @picture # arguments are correct

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