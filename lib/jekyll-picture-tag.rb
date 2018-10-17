module PictureTag
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
  class Picture < Liquid::Tag
    require_relative 'jekyll-picture-tag/generated_file'
    require_relative 'jekyll-picture-tag/instruction_set'
    require_relative 'jekyll-picture-tag/picture_element'
    require_relative 'jekyll-picture-tag/source'
    attr_reader :context, :instructions
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    def render(context)
      # Gather settings
      @instructions = InstructionSet.new(raw_params, context)

      # Prevent Jekyll from erasing our generated files.  This should possibly
      # be an installation instruction, I'm not a huge fan of modifying site
      # settings at runtime.
      unless site.config['keep_files'].include?(@instructions.source_dir)
        site.config['keep_files'] << @instructions.source_dir
      end

      picture_tag = PictureElement.new(@instructions)

      picture_tag.to_s
    end
  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)
