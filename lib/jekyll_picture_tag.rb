require 'objective_elements'

require_relative 'jekyll_picture_tag/generated_image'
require_relative 'jekyll_picture_tag/source_image'
require_relative 'jekyll_picture_tag/instructions'
require_relative 'jekyll_picture_tag/output_formats'
require_relative 'jekyll_picture_tag/srcsets'
require_relative 'jekyll_picture_tag/utils'
require_relative 'jekyll_picture_tag/version'

module PictureTag
  ROOT_PATH = __dir__
  # Title: Jekyll Picture Tag
  # Authors: Rob Wierzbowski   : @robwierzbowski
  #          Justin Reese      : @justinxreese
  #          Welch Canavan     : @xiwcx
  #          Robert Buchberger : @celeritas_5k
  #
  # Description: Easy responsive images for Jekyll.
  #
  # Download: https://github.com/robwierzbowski/jekyll-picture-tag
  # Documentation: https://github.com/robwierzbowski/jekyll-picture-tag/readme.md
  # Issues: https://github.com/robwierzbowski/jekyll-picture-tag/issues
  #
  # Syntax:
  #   {% picture [preset] img.jpg [media_query: alt-img.jpg] [attr="value"] %}
  #
  # Example:
  #   {% picture poster.jpg --alt The strange case of responsive images %}
  #   {% picture gallery poster.jpg source_small: poster_closeus.jpg
  #   alt="The strange case of responsive images" class="gal-img" %}
  #
  # See the documentation for full configuration and usage instructions.
  class Picture < Liquid::Tag
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    def render(context)
      # We can't initialize the tag until we have a context.
      PictureTag.init(@raw_params, context)

      # Return a string:
      build_markup.to_s
    end

    private

    # Super clever metaprogramming. It's the dynamic version of MyClass.new;
    # instantiate the class defined in our config.
    def build_markup
      Object.const_get(output_class).new
    end

    # This is the class name of whichever output format we are selecting:
    def output_class
      'PictureTag::OutputFormats::' + titleize(PictureTag.preset['markup'])
    end

    def titleize(input)
      input.split('_').map(&:capitalize).join
    end
  end
end

Liquid::Template.register_tag('picture', PictureTag::Picture)
