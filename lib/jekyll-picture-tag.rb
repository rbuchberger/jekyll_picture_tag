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
require_relative 'jekyll-picture-tag/defaults'
require_relative 'jekyll-picture-tag/tag_params_parser'
require_relative 'jekyll-picture-tag/picture'

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

    def render(context)
      @context = context

      # Gather settings
      initialize_instructions

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
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
