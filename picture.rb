# Title: Jekyll Picture
# Authors:
# Download:
# Documentation:
#
# Syntax:
# Example:
# Output:

### ruby 1.9

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)

      if markup =~ /^((?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<sources_src>((source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/

        @preset = preset || 'default'
        @image_src = img_src
        @sources_src = sources_src ### create map, each source_key => {:src => source_src}
        @html_attr = html_attr ### create map, each html_attr => value || nil

      else
        raise SyntaxError.new("Your picture tag doesn't seem to be formatted correctly. Try {% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute=\"value\"] %}.")
      end
      super
    end

    def render(context)

      site = context.registers[:site]
      settings = site.config['picture']

      site_path = site.source
      asset_path = settings['asset_path'] || ''
      generated_path = settings['generated_path'] || File.join(asset_path, 'generated')

      markup = settings['markup'] || 'picturefill'

      sources = settings['presets'][@preset]
      html_attr = sources.delete('attr')
      ppi = sources['ppi'] ? sources.delete('ppi').sort.reverse : nil
      source_keys = source.keys

      # Process html_attr
      html_attr.merge!(@html_attr)

      if markup == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = preset['attr'].delete('alt')
      end
      ### Process html_attr into string
      ### pseudo code: each attr, add " "+key, if value add "=\"#{value}\""

      # Process source

      # Add default image source
      sources.each { |key, value| sources[key][:src] = @image_src }

      # Add alternate source images

      ### if @source
      ### Check if each @sources_src property is a sources property
      ### if so, sources.merge!(@sources_src)
      ### else,
        ### raise SyntaxError.new("#{@sources_src[key]} doesn't exist in #{@preset}. Please check _config.yml for available sources.")

      # Add resolution based sources

      ### Not sure what the most elegant way to do this is.
      ### Here's the pieces though, with some suggestions.

      ### if ppi

      ### sources.each { |key, source|
      ### ppi.each { |p|

      ### if p != 1
      ### new_key = key + "_" + (p * 1000)
      ### new_width = source['width'] * p
      ### new_height = source['height'] * p
      ### new_media = source['media'] + " and (min-resolution: " + p + "dppx), " +
      ###             source['media'] + " and (min-resolution: " + (p * 96) + "dpi), " +
      ###             source['media'] + " and (-webkit-min-device-pixel-ratio: " + p + ")"
      ### use existing src

      ### create new hash
      ### append new hash onto end of sources hash

      ### if p > 1, insert new_key before key in source_keys
      ### if p < 1, insert new_key after key in source_keys

      # Generate sized images
      sources.each { |source|
        sources[source][:generated_src] = generate_image(source, site_path, asset_path, generated_path)
      }

      # Construct and return tag

      if settings['markup'] == 'picturefill'

      # <span @tag[:attributes]>
      #   each source_key in @tag[:sources]
      #     if !source_key['source'], source_key['source'] = @image_src
      #   <span data-src="source_key[img_path]" (if media) data-media="source_key[media]"></span>
      #   endeach
      #
      #   <noscript>
      #     <img src="@tag[:sources][source_default][img_path]" alt="@tag[:alt]">
      #   </noscript>
      # </span>

      elsif settings['markup'] == 'picture'

      # <picture @tag[:attributes]>
      #   each source_key in @tag[:sources]
      #   <source src="source_key[img_path]"
      #           (if media) media="source_key[media]">
      #    <img src="small.jpg" alt="">
      #    <p>@tag[:alt]</p>
      # </picture>

      end
    end

    def generate_image(source, site_path, asset_path, generated_path)

      # source_default:
      #   width: "500"
      #   height: "200"
      #   :src: somepath.com/this.img

      # We need
      # abs path orig
      # dimensions
      # abs path generated
      # path for html

      # original_path


      # Get absolute file path
      absolute_orig_image = File.join(site_path, asset_path, source[:src])

      ## RWRW only thing we need these for is constr new name
      ext = File.extname(source[:src])
      orig_name = File.basename(source[:src], src_ext)

      ### orig_width = minimagic something
      ### orig_height = minimagic something

      dest_width = source['width'] || orig_width/orig_height * source['height']
      dest_height = source['height'] || orig_height/orig_width * source['width']
      dest_name = orig_name + '-' + width + '-' + height
      relative_dest_img = File.join(generated_path, dest_name + ext)
      absolute_dest_image = File.join(site_path, generated_path, dest_name + ext)

      # Check if dest image exists
      # Generate missing images with minimagic

      # return relative_dest_img

    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
