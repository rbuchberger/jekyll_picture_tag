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
# Syntax:  {% picture [preset] path/to/img.jpg [source_key: path/to/alt-img.jpg] [attr="value"] %}
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
      @markup = markup
      super
    end

    def render(context)

      # Render any liquid variables in tag arguments and unescape template code
      render_markup = Liquid::Template.parse(@markup).render(context).gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')

      # Gather settings
      site = context.registers[:site]
      settings = site.config['picture']
      markup = /^(?:(?<preset>[^\s.:\/]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source_src>(?:(source_[^\s.:\/]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(render_markup)
      preset = settings['presets'][ markup[:preset] ] || settings['presets']['default']

      raise "Picture Tag can't read this tag. Try {% picture [preset] path/to/img.jpg [source_key: path/to/alt-img.jpg] [attr=\"value\"] %}." unless markup

      # Assign defaults
      settings['source'] ||= '.'
      settings['output'] ||= 'generated'
      settings['markup'] ||= 'picturefill'

      # Prevent Jekyll from erasing our generated files
      site.config['keep_files'] << settings['output'] unless site.config['keep_files'].include?(settings['output'])

      # Deep copy preset for single instance manipulation
      instance = Marshal.load(Marshal.dump(preset))

      # Process alternate source images
      source_src = if markup[:source_src]
        Hash[ *markup[:source_src].gsub(/:/, '').split ]
      else
        {}
      end

      # Process html attributes
      html_attr = if markup[:html_attr]
        Hash[ *markup[:html_attr].scan(/(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?/).flatten ]
      else
        {}
      end

      if instance['attr']
        html_attr = instance.delete('attr').merge(html_attr)
      end

      if settings['markup'] == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = html_attr.delete('alt')
      end

      html_attr_string = html_attr.inject('') { |string, attrs|
        if attrs[1]
          string << "#{attrs[0]}=\"#{attrs[1]}\" "
        else
          string << "#{attrs[0]} "
        end
      }

      # Prepare ppi variables
      ppi = if instance['ppi'] then instance.delete('ppi').sort.reverse else nil end
      # this might work??? ppi = instance.delete('ppi'){ |ppi|  [nil] }.sort.reverse
      ppi_sources = {}

      # Switch width and height keys to the symbols that generate_image() expects
      instance.each { |key, source|
        raise "Preset #{key} is missing a width or a height" if !source['width'] and !source['height']
        instance[key][:width] = instance[key].delete('width') if source['width']
        instance[key][:height] = instance[key].delete('height') if source['height']
      }

      # Store keys in an array for ordering the instance sources
      source_keys = instance.keys
      # used to escape markdown parsing rendering below
      markdown_escape = "\ "

      # Raise some exceptions before we start expensive processing
      raise "Picture Tag can't find the \"#{markup[:preset]}\" preset. Check picture: presets in _config.yml for a list of presets." unless preset
      raise "Picture Tag can't find this preset source. Check picture: presets: #{markup[:preset]} in _config.yml for a list of sources." unless (source_src.keys - source_keys).empty?

      # Process instance
      # Add image paths for each source
      instance.each_key { |key|
        instance[key][:src] = source_src[key] || markup[:image_src]
      }

      # Construct ppi sources
      # Generates -webkit-device-ratio and resolution: dpi media value for cross browser support
      # Reference: http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/
      if ppi
        instance.each { |key, source|
          ppi.each { |p|
            if p != 1
              ppi_key = "#{key}-x#{p}"

              ppi_sources[ppi_key] = {
                :width => if source[:width] then (source[:width].to_f * p).round else nil end,
                :height => if source[:height] then (source[:height].to_f * p).round else nil end,
                'media' => if source['media']
                  "#{source['media']} and (-webkit-min-device-pixel-ratio: #{p}), #{source['media']} and (min-resolution: #{(p * 96).round}dpi)"
                else
                  "(-webkit-min-device-pixel-ratio: #{p}), (min-resolution: #{(p * 96).to_i}dpi)"
                end,
                :src => source[:src]
              }

              # Add ppi_key to the source keys order
              source_keys.insert(source_keys.index(key), ppi_key)
            end
          }
        }
      instance.merge!(ppi_sources)
      end

      # Generate resized images
      instance.each { |key, source|
        instance[key][:generated_src] = generate_image(source, site.source, site.dest, settings['source'], settings['output'], site.config["baseurl"])
      }

      # Construct and return tag
      if settings['markup'] == 'picture'

        source_tags = ''
        source_keys.each { |source|
          media = " media=\"#{instance[source]['media']}\"" unless source == 'source_default'
          source_tags += "#{markdown_escape * 4}<source srcset=\"#{instance[source][:generated_src]}\"#{media}>\n"
        }

        # Note: we can't indent html output because markdown parsers will turn 4 spaces into code blocks
        # Note: Added backslash+space escapes to bypass markdown parsing of indented code below -WD
        picture_tag = "<picture>\n"\
                      "#{source_tags}"\
                      "#{markdown_escape * 4}<img srcset=\"#{instance['source_default'][:generated_src]}\" #{html_attr_string}>\n"\
                      "#{markdown_escape * 2}</picture>\n"

      elsif settings['markup'] == 'img'
        # TODO implement <img srcset/sizes>
      end

        # Return the markup!
        picture_tag
    end

    def generate_image(instance, site_source, site_dest, image_source, image_dest, baseurl)
      image = MiniMagick::Image.open(File.join(site_source, image_source, instance[:src]))
      digest = Digest::MD5.hexdigest(image.to_blob).slice!(0..5)

      image_dir = File.dirname(instance[:src])
      ext = File.extname(instance[:src])
      basename = File.basename(instance[:src], ext)

      orig_width = image[:width].to_f
      orig_height = image[:height].to_f
      orig_ratio = orig_width/orig_height

      gen_width = if instance[:width]
        instance[:width].to_f
      elsif instance[:height]
        orig_ratio * instance[:height].to_f
      else
        orig_width
      end
      gen_height = if instance[:height]
        instance[:height].to_f
      elsif instance[:width]
        instance[:width].to_f / orig_ratio
      else
        orig_height
      end
      gen_ratio = gen_width/gen_height

      # Don't allow upscaling. If the image is smaller than the requested dimensions, recalculate.
      if orig_width < gen_width || orig_height < gen_height
        undersize = true
        gen_width = if orig_ratio < gen_ratio then orig_width else orig_height * gen_ratio end
        gen_height = if orig_ratio > gen_ratio then orig_height else orig_width/gen_ratio end
      end

      gen_name = "#{basename}-#{gen_width.round}by#{gen_height.round}-#{digest}#{ext}"
      gen_dest_dir = File.join(site_dest, image_dest, image_dir)
      gen_dest_file = File.join(gen_dest_dir, gen_name)

      # Generate resized files
      unless File.exists?(gen_dest_file)

        warn "Warning:".yellow + " #{instance[:src]} is smaller than the requested output file. It will be resized without upscaling." if undersize

        #  If the destination directory doesn't exist, create it
        FileUtils.mkdir_p(gen_dest_dir) unless File.exist?(gen_dest_dir)

        # Let people know their images are being generated
        puts "Generating #{gen_name}"

        # Scale and crop
        image.combine_options do |i|
          i.resize "#{gen_width}x#{gen_height}^"
          i.gravity "center"
          i.crop "#{gen_width}x#{gen_height}+0+0"
        end

        image.write gen_dest_file
      end

      # Return path relative to the site root for html
      Pathname.new(File.join(baseurl, image_dest, image_dir, gen_name)).cleanpath
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
