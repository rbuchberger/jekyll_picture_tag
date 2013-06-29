# Title: Jekyll Picture
# Authors:
# Download:
# Documentation:
#
# Syntax:
# Example:
# Output:

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)

      if markup =~ /^((?<preset>[^\s.:]+)\s+)?(?<img_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source>((source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/

        @preset = preset
        @img_src = img_src
        @source = source # create map, each source_key: source_src
        @html_attr = html_attr # create map, each html_attr: value. If no value, set to false or null

      else
        raise SyntaxError.new("Your picture tag doesn't seem to be formatted correctly. Try {% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute=\"value\"] %}.")
      end
      super
    end

    def render(context)

      site = context.registers[:site]
      settings = site.config['picture']
      preset = settings['presets'][@preset]

      src_path = File.join(site.source, settings['src'])
      dest_path = File.join(site.source, settings['dest'])

      # @settings[presets][@tag[:preset]][attr]
      # Have to split attr into array/map, merge with preset attr, then re-render.
        # hash1.merge(hash2)
        # duplicate keys in hash2 will overwrite the ones in hash1

        # add data-picture, if markup picturefill replace alt -> data-alt

      # add source_key source, then if !source_key.source use img_src

      # if @tag[:sources][ppi] generate extra source keys
        # add new source_key in correct place
        # new width, height
        # new media with cross browser mq
      # remove @tag[:sources][ppi]

      # each {| source_key, settings |

        # available:
        # settings[media]
        # settings[width]
        # settings[height]

        # create generated img paths: jekyll absolute path + jekyll config source path + @settings[dest_dir]
        # add @tag[:sources][source_key][img_path]

        # generate_image()


      if @picture # arguments are correct

      # construct and return tag

      # if picturefill

      # <span @tag[:attributes]>
      #   each source_key in @tag[:sources]
      #   <span data-src="source_key[img_path]" (if media) data-media="source_key[media]"></span>
      #   endeach
      #
      #   <noscript>
      #     <img src="@tag[:sources][source_default][img_path]" alt="@tag[:alt]">
      #   </noscript>
      # </span>

      # if picture

      # <picture @tag[:attributes]>
      #   each source_key in @tag[:sources]
      #   <source src="source_key[img_path]"
      #           (if media) media="source_key[media]">
      #    <img src="small.jpg" alt="">
      #    <p>@tag[:alt]</p>
      # </picture>

      else
        "Error processing input. Expected syntax: {% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute=\"value\"] %}"
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
