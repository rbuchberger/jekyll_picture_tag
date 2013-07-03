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

      tag = /^(?:(?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source_src>(?:(source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(markup)

      raise "A picture tag is formatted incorrectly. "\
      "Try {% picture [preset] path/to/img.jpg [source_key: path/to/alt-img.jpg] [attr=\"value\"] %}." unless tag

      @preset = tag[:preset] || 'default'
      @image_src = tag[:image_src]
      @source_src = if tag[:source_src]
        Hash[ *tag[:source_src].gsub(/:/, '').split ]
      else
        {}
      end
      @html_attr = if tag[:html_attr]
        Hash[ *tag[:html_attr].scan(/(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?/).flatten ]
      else
        {}
      end

      super
    end

    def render(context)

      # Gather picture settings, assign defaults
      site = context.registers[:site]
      settings = site.config['picture']
      site_path = site.source
      markup = settings['markup'] || 'picturefill'
      asset_path = settings['asset_path'] || '.'
      gen_path = settings['generated_path'] || File.join(asset_path, 'generated')

      # Create sources object and gather sources settings

      raise "You've specified a picture preset that doesn't exist." unless settings['presets'][@preset]

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
                'media' => if value['media'] then "#{value['media']} and (-webkit-min-device-pixel-ratio: #{p}), #{value['media']} and (min-resolution: #{(p * 96).round}dpi)" else "(-webkit-min-device-pixel-ratio: #{p}), (min-resolution: #{(p * 96).to_i}dpi)" end,
                :src => value[:src]
              }

              source_keys.insert(source_keys.index(key), ppi_key)
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

      ## Could do the array, join with \n
#  a ||= 'a' trick

### Multi line interpolation
# conn.exec %Q{select attr1, attr2, attr3, attr4, attr5, attr6, attr7
#       from #{table_names},
#       where etc etc etc etc etc etc etc etc etc etc etc etc etc}




      if settings['markup'] == 'picturefill'

        source_tags = ''
        source_keys.each { |source|
          media = if sources[source]['media'] then " data-media=\"#{sources[source]['media']}\"" end
          source_tags += "<span data-src=\"#{sources[source][:generated_src]}\"#{media}></span>\n"
        }

        # Note: we can't indent here because markdown parsers will turn 4 spaces into code blocks
        picture_tag = "<span #{html_attr_string}>\n"\
                      "#{source_tags}\n"\
                      "<noscript>\n"\
                      "<img src=\"#{sources['source_default'][:generated_src]}\" alt=\"#{html_attr['data-alt']}\">\n"\
                      "</noscript>\n"\
                      "</span>\n"

      elsif settings['markup'] == 'picture'

        source_tags = ''
        source_keys.each { |source|
          media = if sources[source]['media'] then " media=\"#{sources[source]['media']}\"" end
          source_tags += "<source src=\"#{sources[source][:generated_src]}\"#{media}>\n"
        }

        # Note: we can't indent here because markdown parsers will turn 4 spaces into code blocks
        picture_tag = "<picture #{html_attr_string}>\n"\
                      "#{source_tags}\n"\
                      "<p>#{html_attr['alt']}></p>\n"\
                      "</picture>\n"

      end

        # Return it
        picture_tag
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

      #### Add warning for too small imgs
      # warn 'shit is real son'.yellow
      # Let people know their images are being generated
      # puts "Thumbnailing #{source} to #{dest} (#{dimensions})"


      ### Need to round calcs, or does minimaj take care of that?
      ### Clean up all the to_i/f in here
      gen_width = source['width'] ? source['width'].to_i : (src_ratio * source['height'].to_f).to_i
      gen_height = source['height'] ? source['height'].to_i : (source['width'].to_f / src_ratio).to_i
      gen_ratio = gen_width.to_f/gen_height.to_f

      #### RWRW Add hash to name
      #### Cleanup needs to be manual...
      gen_name = "#{src_name}-#{gen_width}x#{gen_height}-#{src_digest}"
      gen_absolute_path = File.join(site_path, gen_path, src_dir, gen_name + ext)

      #### RWRW must be abs path from site root
      gen_return_path = File.join('/', gen_path, src_dir, gen_name + ext)

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
