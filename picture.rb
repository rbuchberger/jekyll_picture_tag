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

      if markup =~ /^((?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<sources_src>((source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/

        @preset = preset
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

      src_path = File.join(site.source, settings['src'])
      dest_path = File.join(site.source, settings['dest'])

      sources = settings['presets'][@preset]
      html_attr = sources.delete('attr') ### Will this error out if attr/ppi are absent?
      ppi = sources.delete('ppi').sort.reverse ### Will this error out if attr/ppi are absent?
      source_keys = source.keys

      ### Set settings defaults?

      # Process html_attr
      html_attr.merge!(@html_attr)

      if settings['markup'] == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = preset['attr'].delete('alt')
      end

      ### process into string

      # Process source
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
      ### append new hash onto end of source hash

      ### if p > 1, insert new_key before key in source_keys
      ### if p < 1, insert new_key after key in source_keys

      # Generate sized images
      sources.each { |source|
        src = source['src'] || @image_src
        sources[source][:generated_src] = generate_image(src, src_path, dest_path, source['width'], source['height'])
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

    def generate_image(src, src_path, dest_path, width, height)

      # Get absolute file path
      src_image = File.join(src_path, src)
      src_path = File.dirname(src_image)
      src_basename = File.basename(src_image, src_ext)
      ext = File.extname(src_image)
      # src_width = minimagic something
      # src_height = minimagic something

      dest_width = width || src_width/src_height * height
      dest_height = height || src_height/src_width * width
      dest_basename = src_basename + "-" + width + "-" + height

      # Check if dest image exists
      # Generate missing images with minimagic

      # image destination file name: src_name-WIDTH-HEIGHT.ext
      #                              cat-250-200.jpg

      # return generated image name/local path

    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
