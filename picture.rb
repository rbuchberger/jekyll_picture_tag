# Title: Jekyll Picture
# Authors:
# Download:
# Documentation:
#
# Syntax:
# Example:
# Output:

### ruby 1.9+

require 'mini_magick'

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)

      if @tag = /^(?:(?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<sources_src>(?:(source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(markup)
        @preset = @tag[:preset] || 'default'
        @image_src = @tag[:image_src]

        @sources = {}
        @tag[:sources_src].split.each_slice(2) do |set|
          @sources.merge! Hash[*set]
        end

        @html_attr = {}
        @tag[:html_attr].scan(/(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?/).each do |html_attr|
          @html_attr.merge! Hash[*html_attr]
        end
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
      source_keys = sources.keys

      # Process html_attr
      html_attr.merge!(@html_attr)

      if markup == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = @html_attr.delete('alt')
      end

      # Process html_attr into string.
      html_attr_string = ""
      html_attr.each {|key, value|
        if value
          html_attr_string += "#{key}=\"#{value}\" "
        else
          html_attr_string += "#{key} "
        end
      }

      # Process source

      # Add image path for each source
      sources.each { |key, value|
        sources[key] = @sources.fetch(key, @image_src)
      }

      ### check if sources don't exist in preset, raise error?
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
      ###             source['media'] + " and (min-resolution: " + (p * 96) + "dpi)"
      ### use existing src
      ### MQ Reference: http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/

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

      ### Not updated for new variables
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

      ### Not updated for new variables
      # <picture @tag[:attributes]>
      #   each source_key in @tag[:sources]
      #   <source src="source_key[img_path]"
      #           (if media) media="source_key[media]">
      #    <img src="small.jpg" alt="">
      #    <p>@tag[:alt]</p>
      # </picture>

      end
    end

    def generate_image(source, site_path, asset_path, gen_path)

      ### Source input
      # source_default:
      #   width: "500"
      #   height: "200"
      #   :src: somepath.com/this.img

      if source['width'].nil? && source['height'].nil?
        raise SyntaxError.new("Source keys must have at least one of width and height. Please check _config.yml.")
      end

      ### Damn, this is so many vars. Can it be simplified?

      ori_dir = File.dirname(source[:src])
      ext = File.extname(source[:src])
      ori_name = File.basename(source[:src], ext)
      ori_image = MiniMagick::Image.open(File.join(site_path, asset_path, source[:src]))

      ori_ratio = ori_image[:width]/ori_image[:height]

      ### Need to round calcs, or does minimaj take care of that?
      gen_width = source['width'].to_i || ori_ratio * source['height'].to_i
      gen_height = source['height'].to_i || ori_ratio/source['width'].to_i

      gen_name = "#{base_name}-#{gen_width}-#{gen_height}"
      gen_absolute_path = File.join(site_path, gen_path, ori_dir, gen_name + ext)
      gen_return_path = File.join(gen_path, ori_dir, gen_name + ext)

      if not File.exists?(gen_absolute_path)
        ori_image.combine_options do |i|
          i.resize "#{gen_width}-#{gen_height}^"

          # get which doesn't match?
          if i[:width] != gen_width
            i.shave "#{(i[:width] - gen_width)/2}x0"
          elsif i[:height] != gen_height
            i.shave "0x#{(i[:height] - gen_height)/2}"
          end

          ### Do we need an absolute path, or can we do everything locally?
          ### What is cwd?
          i.write gen_absolute_path
        end
      end

      gen_return_path
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
picture = Jekyll::Picture.new("","preset_name path/to/img.jpg source_anything: path/to/alt/img.jpg source_second: path/to/second/img.jpg alt=\"alt_text\" disabled title=\"title text\"", "")
