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
require 'fastimage'
require 'objective_elements'
require_relative 'jekyll-picture-tag/defaults'
require_relative 'jekyll-picture-tag/tag_params_parser'
require_relative 'jekyll-picture-tag/markup_generator'
require_relative 'jekyll-picture-tag/image_generator'

module PictureTag
  class Picture < Liquid::Tag
    attr_reader :context, :instructions
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    def site
      # Global site data
      context.registers[:site]
    end

    def presets
      # Read presets from _data/picture.yml
      site.data['picture']
    end

    def preset
      # Which preset we're using for this tag
      presets[@instructions[:preset_name]]
    end

    def url
      # site url, example.com/
      site.config['url'] || ''
    end

    def baseurl
      # example.com/baseurl/
      site.config['baseurl'] || ''
    end

    def ppi_list
      if preset['ppi']
        preset['ppi'].map(&:to_i)
      else
        [1]
      end
    end

    def initialize_instructions
      # This represents a complete combination of all decision making
      # information. It combines our defaults, site configuration, and tag
      # parameters into a plan of execution.

      # Set defaults
      @instructions = defaults

      # Add config
      site.config['picture'].each_pair do |key, val|
        @instructions[key.to_sym] = val.dup
      end

      # Add params
      @instructions.merge! parse_tag_params(@raw_params, context)
    end

    def filename(source_filename, source_name, ppi, format)
      name = "#{source_filename}_#{source_name}"
      name << "#{ppi}x" unless ppi == 1
      name << ".#{format}"
    end

    def sources
      # Keys are source names, values are properties
      source_hash = {}

      preset['sources'].each_pair do |source, properties|
        source_hash[source] = {
          source_file: @instructions[:source_images]['source']
        }.merge(properties.transform_keys(&:to_sym))
      end

      source_hash
    end

    def render(context)
      @context = context
      # Gather settings

      initialize_instructions

      unless instructions[:source_image] =~ /\s+.\w{1,5}/
        raise <<-HEREDOC




        Picture Tag can't read this tag. Try {% picture [preset] path/to/img.jpg [source_key:
        path/to/alt-img.jpg] [attr=\"value\"] %}.
        HEREDOC
      end

      # Prevent Jekyll from erasing our generated files.  This should possibly
      # be an installation instruction, I'm not a huge fan of modifying site
      # settings at runtime.
      unless site.config['keep_files'].include?(@instructions[:source_dir])
        site.config['keep_files'] << @instructions[:source_dir]
      end

      # Generate resized images
      instance.each do |key, source|
        instance[key][:generated_src] = generate_image(source, site.source, site.dest, config_settings['source'], config_settings['output'], baseurl)
      end

      # Construct and return tag
      if config_settings['markup'] == 'picture'
        source_tags = ''
        source_keys.each do |source|
          media = " media=\"#{instance[source]['media']}\"" unless source == 'source_default'
          source_tags += "#{markdown_escape * 4}<source srcset=\"#{url}#{instance[source][:generated_src]}\"#{media}>\n"
        end

        # Note: we can't indent html output because markdown parsers will turn 4 spaces into code blocks
        # Note: Added backslash+space escapes to bypass markdown parsing of indented code below -WD
        picture_tag = "<picture>\n"\
                      "#{source_tags}"\
                      "#{markdown_escape * 4}<img src=\"#{url}#{instance['source_default'][:generated_src]}\" #{html_attr_string}>\n"\
                      "#{markdown_escape * 2}</picture>\n"
      elsif config_settings['markup'] == 'interchange'

        interchange_data = []
        source_keys.reverse_each do |source|
          interchange_data << "[#{url}#{instance[source][:generated_src]}, #{source == 'source_default' ? '(default)' : instance[source]['media']}]"
        end

        picture_tag = %(<img data-interchange="#{interchange_data.join ', '}" #{html_attr_string} />\n)
        picture_tag += %(<noscript><img src="#{url}#{instance['source_default'][:generated_src]}" #{html_attr_string} /></noscript>)

      elsif config_settings['markup'] == 'img'
        # TODO: Implement sizes attribute
        picture_tag = SingleTag.new 'img'

        source_keys.each do |source|
          val = "#{url}#{instance[source][:generated_src]} #{instance[source][:width]}w,"
          picture_tag.add_attributes srcset: val
          # Note the last value will have a comma hanging off the end of it.
        end
        picture_tag.add_attributes src: "#{url}#{instance['source_default'][:generated_src]}"
        picture_tag.add_attributes html_attr_string
      end

      # Return the markup!
      picture_tag.to_s
    end

    def generate_image(instance, site_source, site_dest, image_source, image_dest, baseurl)
      begin
        digest = Digest::MD5.hexdigest(File.read(File.join(site_source, image_source, instance[:src]))).slice!(0..5)
      rescue Errno::ENOENT
        warn 'Warning:'.yellow + " source image #{instance[:src]} is missing."
        return ''
      end

      image_dir = File.dirname(instance[:src])
      ext = File.extname(instance[:src])
      basename = File.basename(instance[:src], ext)

      size = FastImage.size(File.join(site_source, image_source, instance[:src]))
      orig_width = size[0]
      orig_height = size[1]
      orig_ratio = orig_width * 1.0 / orig_height

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
      gen_ratio = gen_width / gen_height

      # Don't allow upscaling. If the image is smaller than the requested dimensions, recalculate.
      if orig_width < gen_width || orig_height < gen_height
        undersize = true
        gen_width = orig_ratio < gen_ratio ? orig_width : orig_height * gen_ratio
        gen_height = orig_ratio > gen_ratio ? orig_height : orig_width / gen_ratio
      end

      gen_name = "#{basename}-#{gen_width.round}by#{gen_height.round}-#{digest}#{ext}"
      gen_dest_dir = File.join(site_dest, image_dest, image_dir)
      gen_dest_file = File.join(gen_dest_dir, gen_name)

      # Generate resized files
      unless File.exist?(gen_dest_file)

        warn 'Warning:'.yellow + " #{instance[:src]} is smaller than the requested output file. It will be resized without upscaling." if undersize

        #  If the destination directory doesn't exist, create it
        FileUtils.mkdir_p(gen_dest_dir) unless File.exist?(gen_dest_dir)

        # Let people know their images are being generated
        puts "Generating #{gen_name}"

        image = MiniMagick::Image.open(File.join(site_source, image_source, instance[:src]))
        # Scale and crop
        image.combine_options do |i|
          i.resize "#{gen_width}x#{gen_height}^"
          i.gravity 'center'
          i.crop "#{gen_width}x#{gen_height}+0+0"
          i.strip
        end

        image.write gen_dest_file
      end

      # Return path relative to the site root for html
      Pathname.new(File.join(baseurl, image_dest, image_dir, gen_name)).cleanpath
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
