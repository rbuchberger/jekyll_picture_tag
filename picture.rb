module Jekyll

  class Picture < Liquid::Tag
    @picture = nil

    def initialize(tag_name, markup, tokens)

      # if picture arguments are correct

      # Regex out arguments
      @markup = regex here

      @image_src  = regex part
      @attr       = regex part
      # capture alt value from attr
      @alt        = regex part
      @preset     = regex part
      @media_src  = regex part

      # string replace alt=" with data-alt=" in attr.

      super
    end

    def render(context)

      # Get liquid_picture obj from _config.yml
      # @settings = config[liquid_picture]
      # to be used:
      # @settings[src_dir]
      # @settings[dest_dir]

      # @sources = @settings[presets][@preset]

      # if @sources[ppi] generate extra media keys
        # add new media key in correct place
        # new width, height
        # new media with cross browser mq
      # remove @sources[ppi]

      # each {| media_key, settings |

        # available:
        # settings[media]
        # settings[width]
        # settings[height]

        # create generated img paths: jekyll absolute path + jekyll config source path + @settings[dest_dir]
        # add @sources[media_key][img_path]

        # generate_image()


      if @picture # arguments are correct

      # construct and return tag

      # <span @attr>
      #   each media_key in @sources
      #   <span data-src="media_key[img_path]" (if media) data-media="media_key[media]"></span>
      #   endeach
      #
      #   <noscript>
      #     <img src="@sources[media_default][img_path]" alt="@alt">
      #   </noscript>
      # </span>

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