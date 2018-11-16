require 'objective_elements'
require 'pry'

require_relative 'jekyll-picture-tag/generated_image'
require_relative 'jekyll-picture-tag/instruction_set'
require_relative 'jekyll-picture-tag/output_formats'
require_relative 'jekyll-picture-tag/srcsets'
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
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    def render(context)
      # Build Configuration
      PictureTag.init(@raw_params, context)

      # This is the class name of whichever output format we are selecting:
      output_class =
        'PictureTag::OutputFormats::' +
        PictureTag.config.output_format.capitalize

      # Create a new instance of the class named in output_class. This syntax
      # allows us to do it dynamically:
      markup = Object.const_get(output_class).new

      # Return a string:
      markup.to_s
    end
  end
end

Liquid::Template.register_tag('picture', PictureTag::Picture)
