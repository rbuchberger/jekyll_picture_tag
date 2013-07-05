# Title: Jekyll Picture Tag
# Authors: Rob Wierzbowski : @robwierzbowski
#          Justin Reese    : @justinxreese
#          Welch Canavan   : @xiwcx
#
# Description: Easy responsive images for Jekyll.
#
# Download: https://github.com/robwierzbowski/jekyll-picture-tag
# Documentation: https://github.com/robwierzbowski/jekyll-picture-tag/readme.md
# Issues: https://github.com/robwierzbowski/jekyll-picture-tag/issues
#
# Syntax:  {% picture [preset] path/to/img.jpg [source_key: path/to/alt-img.jpg] [attr=\"value\"] %}
# Example: {% picture poster.jpg alt="The strange case of responsive images" %}
#          {% picture gallery poster.jpg source_small: poster_closeup.jpg
#             alt="The strange case of responsive images" class="gal-img" data-selected %}
#
# See the documentation for full configuration and usage instructions.

require 'fileutils'
require 'pathname'
require 'digest/md5'
require 'mini_magick'

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)

      tag = /^(?:(?<preset>[^\s.:\/]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source_src>(?:(source_[^\s.:\/]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(markup)

      raise "Picture Tag can't read this tag. Try {% picture [preset] path/to/img.jpg [source_key: path/to/alt-img.jpg] [attr=\"value\"] %}." unless tag

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

      # Gather settings
      site = context.registers[:site]
      settings = site.config['picture']
      markup = settings['markup'] || 'picturefill'
      image_source = settings['source_path'] || '.'
      image_dest = settings['output_path'] || File.join(image_source, 'generated')

      # Prevent Jekyll from erasing our copied files
      site.config['keep_files'] << image_dest unless site.config['keep_files'].include?(image_dest)

      # Deep copy preset to sources for single instance manipulation
      sources = Marshal.load(Marshal.dump(settings['presets'][@preset]))

      # Process html attributes
      html_attr = if sources['attr']
        sources.delete('attr').merge!(@html_attr)
      else
        @html_attr
      end

      if markup == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = html_attr.delete('alt')
      end

      html_attr_string = ''
      html_attr.each { |key, value|
        if value && value != 'nil'
          html_attr_string += "#{key}=\"#{value}\" "
        else
          html_attr_string += "#{key} "
        end
      }

      # Prepare ppi variables
      ppi = if sources['ppi'] then sources.delete('ppi').sort.reverse else nil end
      ppi_sources = {}

      # Store source keys in an array for ordering the sources object
      source_keys = sources.keys

      # Raise some exceptions before we start expensive processing
      raise "Picture Tag can't find this preset. Check picture: presets: #{@preset} in _config.yml for a list of presets." unless settings['presets'][@preset]
      raise "Picture Tag can't find this preset source. Check picture: presets: #{@preset} in _config.yml for a list of sources." unless (@source_src.keys - source_keys).empty?

      # Process sources
      # Add image paths for each source
      sources.each_key { |key|
        sources[key][:src] = @source_src[key] || @image_src
      }

      # Construct ppi sources
      # Generates -webkit-device-ratio and resolution: dpi media value for cross browser support
      # Reference: http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/
      if ppi
        sources.each { |key, value|
          ppi.each { |p|
            if p != 1
              ppi_key = "#{key}-x#{p}"

              ppi_sources[ppi_key] = {
                'width' => if value['width'] then (value['width'].to_f * p).round else nil end,
                'height' => if value['height'] then (value['height'].to_f * p).round else nil end,
                'media' => if value['media']
                  "#{value['media']} and (-webkit-min-device-pixel-ratio: #{p}), #{value['media']} and (min-resolution: #{(p * 96).round}dpi)"
                else
                  "(-webkit-min-device-pixel-ratio: #{p}), (min-resolution: #{(p * 96).to_i}dpi)"
                end,
                :src => value[:src]
              }

              # Add ppi_key to the source keys order
              source_keys.insert(source_keys.index(key), ppi_key)
            end
          }
        }
      sources.merge!(ppi_sources)
      end

      # Generate resized images
      sources.each { |key, source|
        sources[key][:generated_src] = generate_image(source, site.source, site.dest, image_source, image_dest)
      }

      # Construct and return tag
      if settings['markup'] == 'picturefill'

        source_tags = ''
        # Picturefill uses reverse source order
        # Reference: https://github.com/scottjehl/picturefill/issues/79
        source_keys.reverse.each { |source|
          media = " data-media=\"#{sources[source]['media']}\"" unless source == 'source_default'
          source_tags += "<span data-src=\"#{sources[source][:generated_src]}\"#{media}></span>\n"
        }

        # Note: we can't indent html output because markdown parsers will turn 4 spaces into code blocks
        picture_tag = "<span #{html_attr_string}>\n"\
                      "#{source_tags}"\
                      "<noscript>\n"\
                      "<img src=\"#{sources['source_default'][:generated_src]}\" alt=\"#{html_attr['data-alt']}\">\n"\
                      "</noscript>\n"\
                      "</span>\n"

      elsif settings['markup'] == 'picture'

        source_tags = ''
        source_keys.each { |source|
          media = " media=\"#{sources[source]['media']}\"" unless source == 'source_default'
          source_tags += "<source src=\"#{sources[source][:generated_src]}\"#{media}>\n"
        }

        # Note: we can't indent html output because markdown parsers will turn 4 spaces into code blocks
        picture_tag = "<picture #{html_attr_string}>\n"\
                      "#{source_tags}"\
                      "<p>#{html_attr['alt']}</p>\n"\
                      "</picture>\n"
      end

        # Return the markup!
        picture_tag
    end

    def generate_image(source, site_source, site_dest, image_source, image_dest)

      raise "Sources must have at least one of width and height in the _config.yml." unless source['width'] || source['height']

      src_image = MiniMagick::Image.open(File.join(site_source, image_source, source[:src]))
      src_digest = Digest::MD5.hexdigest(src_image.to_blob).slice!(0..5)
      src_width = src_image[:width].to_f
      src_height = src_image[:height].to_f
      src_ratio = src_width/src_height
      src_dir = File.dirname(source[:src])
      ext = File.extname(source[:src])
      src_name = File.basename(source[:src], ext)

      gen_width = if source['width'] then source['width'].to_f else src_ratio * source['height'].to_f end
      gen_height = if source['height'] then source['height'].to_f else source['width'].to_f / src_ratio end
      gen_ratio = gen_width/gen_height

      # Don't allow upscaling. If the image is smaller than the requested dimensions, recalculate.
      if src_image[:width] < gen_width || src_image[:height] < gen_height
        undersized = true
        gen_width = if gen_ratio < src_ratio then src_height * gen_ratio else src_width end
        gen_height = if gen_ratio > src_ratio then src_width/gen_ratio else src_height end
      end

      gen_name = "#{src_name}-#{gen_width.round}x#{gen_height.round}-#{src_digest}" + ext
      gen_dest_path = File.join(site_dest, image_dest, src_dir)
      gen_jekyll_path = Pathname.new(File.join('/', image_dest, src_dir, gen_name)).cleanpath

      # Generate resized files
      unless File.exists?(File.join(gen_dest_path, gen_name))

        warn "Warning:".yellow + " #{source[:src]} is smaller than the requested output file. It will be resized without upscaling." unless not undersized

        #  If the destination directory doesn't exist, create it
        FileUtils.mkdir_p(gen_dest_path) unless File.exist?(gen_dest_path)

        # Let people know their images are being generated
        puts "Generating #{gen_name}"

        # Scale and crop
        src_image.combine_options do |i|
          i.resize "#{gen_width.round}x#{gen_height.round}^"
          i.gravity "center"
          i.crop "#{gen_width.round}x#{gen_height.round}+0+0"
        end
        src_image.write File.join(gen_dest_path, gen_name)
      end

      # Return path for html
      gen_jekyll_path
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
