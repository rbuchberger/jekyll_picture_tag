# Title: Jekyll Picture
# Authors:
# Download:
# Documentation:
#
# Syntax:
# Example:
# Output:

### ruby 1.9+

require 'fileutils'
require 'mini_magick'
require 'digest/md5'
require 'pathname'

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)

      if tag = /^(?:(?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source_src>(?:(source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(markup)

        @preset = tag[:preset] || 'default'
        @image_src = tag[:image_src]
        @source_src = {}
        if tag[:source_src]
          @source_src = Hash[ *tag[:source_src].gsub(/:/, '').split ]
        end
        @html_attr = {}
        if tag[:html_attr]
          tag[:html_attr].scan(/(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?/).each do |html_attr|
            @html_attr.merge! Hash[*html_attr]
          end
        end

      else
        raise SyntaxError.new("A picture tag is formatted incorrectly. Try {% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute=\"value\"] %}.")
      end
      super
    end

    def render(context)

      # Gather picture settings
      site = context.registers[:site]
      settings = site.config['picture']
      site_path = site.source
      markup = settings['markup'] || 'picturefill'
      asset_path = settings['asset_path'] || ''
      gen_path = settings['generated_path'] || File.join(asset_path, 'generated')

      # Create sources object and gather sources settings

      if settings['presets'][@preset].nil?
        raise SyntaxError.new("You've specified a picture preset that doesn't exist.")
      end

      # Deep copy preset for manipulation
      sources = Marshal.load(Marshal.dump(settings['presets'][@preset]))
      html_attr = if sources['attr'] then sources.delete('attr').merge!(@html_attr) else @html_attr end
      ppi = if sources['ppi'] then sources.delete('ppi').sort.reverse else nil end
      ppi_sources = {}
      source_keys = sources.keys ### rename source_order?

      # Process attributes
      if markup == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = html_attr.delete('alt')
      end

      html_attr_string = ''
      html_attr.each {|key, value|
        if value
          html_attr_string += "#{key}=\"#{value}\" "
        else
          html_attr_string += "#{key} "
        end
      }

      # Process sources
      if (@source_src.keys - source_keys).any?
        raise SyntaxError.new("You're trying to specify an image for a source that doesn't exist. Please check picture: presets: #{@preset} in your _config.yml for the list of available sources.")
      end

      # Add image paths for each source
      sources.each { |key, value|
        sources[key][:src] = @source_src[key] || @image_src

        # Create ppi sources
        if ppi
          ppi.each { |p|
            if p != 1
              ppi_key = "#{key}-x#{p}"

              ppi_sources[ppi_key] = {
                # Don't need to check existance -- if they're not set will return nil
                'width' => if value['width'] then (value['width'].to_f * p).round else nil end,
                'height' => if value['height'] then (value['height'].to_f * p).round else nil end,
                # MQ Reference: http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/
                'media' => "#{value['media']} and (min-resolution: #{p}dppx), #{value['media']} and (min-resolution: #{(p * 96)}dpi)",
                :src => value[:src]
              }

              key_index = if p > 1 then source_keys.index(key) else source_keys.index(key) + 1 end
              source_keys.insert(key_index, ppi_key)
            end
          }
        end
      }

      sources.merge!(ppi_sources)

      # Generate sized images
      sources.each { |key, source|
        sources[key][:generated_src] = generate_image(source, site_path, asset_path, gen_path)
      }

      # Construct and return tag

      "<pre>Hey dog!</pre>"

      # if settings['markup'] == 'picturefill'

      # ### Not updated for new variables
      # # <span tag[:attributes]>
      # #   each source_key in @tag[:sources]
      # #     if !source_key['source'], source_key['source'] = @image_src
      # #   <span data-src="source_key[img_path]" (if media) data-media="source_key[media]"></span>
      # #   endeach
      # #
      # #   <noscript>
      # #     <img src="@tag[:sources][source_default][img_path]" alt="@tag[:alt]">
      # #   </noscript>
      # # </span>

      # elsif settings['markup'] == 'picture'

      # ### Not updated for new variables
      # # <picture @tag[:attributes]>
      # #   each source_key in @tag[:sources]
      # #   <source src="source_key[img_path]"
      # #           (if media) media="source_key[media]">
      # #    <img src="small.jpg" alt="">
      # #    <p>@tag[:alt]</p>
      # # </picture>

      # end
    end

    def generate_image(source, site_path, asset_path, gen_path)

      if source['width'].nil? && source['height'].nil?
        raise SyntaxError.new("Source keys must have at least one of width and height in the _config.yml.")
      end

      src_dir = File.dirname(source[:src])
      ext = File.extname(source[:src])
      src_name = File.basename(source[:src], ext)
      src_image = MiniMagick::Image.open(File.join(site_path, asset_path, source[:src]))
      src_ratio = src_image[:width].to_f / src_image[:height].to_f
      src_digest = Digest::MD5.hexdigest(src_image.to_blob).slice!(0..5)


      ### Need to round calcs, or does minimaj take care of that?
      ### Clean up all the to_i/f in here
      gen_width = source['width'] ? source['width'].to_i : (src_ratio * source['height'].to_f).to_i
      gen_height = source['height'] ? source['height'].to_i : (source['width'].to_f / src_ratio).to_i
      gen_ratio = gen_width.to_f/gen_height.to_f

      #### RWRW Add hash to name
      #### Cleanup needs to be manual...
      gen_name = "#{src_name}-#{gen_width}x#{gen_height}-#{src_digest}"
      gen_absolute_path = File.join(site_path, gen_path, src_dir, gen_name + ext)
      gen_return_path = File.join(gen_path, src_dir, gen_name + ext)

      if not File.exists?(gen_absolute_path)

        ### create the directory if it doesnt exist
        if not File.exist?(File.join(site_path, gen_path))
          FileUtils.mkdir_p(File.join(site_path, gen_path))
        end

        src_image.combine_options do |i|
          i.resize "#{gen_width}x#{gen_height}^"
          i.gravity "center"
          i.crop "#{gen_width}x#{gen_height}+0+0"
        end

        src_image.write gen_absolute_path
      end

      # Return path with superfluous dots removed
      Pathname.new(gen_return_path).cleanpath
    end

  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
