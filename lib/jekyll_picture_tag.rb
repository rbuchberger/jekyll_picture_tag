require 'jekyll'
require 'objective_elements'

require_relative 'jekyll_picture_tag/generated_image'
require_relative 'jekyll_picture_tag/instructions'
require_relative 'jekyll_picture_tag/output_formats'
require_relative 'jekyll_picture_tag/source_image'
require_relative 'jekyll_picture_tag/srcsets'
require_relative 'jekyll_picture_tag/utils'
require_relative 'jekyll_picture_tag/img_uri'
require_relative 'jekyll_picture_tag/router'

# Title: Jekyll Picture Tag
# Authors: Rob Wierzbowski   : @robwierzbowski
#          Justin Reese      : @justinxreese
#          Welch Canavan     : @xiwcx
#          Robert Buchberger : @celeritas_5k
#
# Description: Easy responsive images for Jekyll.
#
# Download: https://rubygems.org/gems/jekyll_picture_tag
# Documentation: https://rbuchberger.github.io/jekyll_picture_tag/
# Issues: https://github.com/rbuchberger/jekyll_picture_tag/
#
# Syntax:
# {% picture [preset] img.jpg [media_query: alt-img.jpg] [attributes] %}
#
# Examples:
#
#   {% picture poster.jpg --alt The strange case of responsive images %}
#
#   {% picture
#      gallery
#      poster.jpg
#      source_small: poster_closeus.jpg
#      --alt The strange case of responsive images
#      --img class="gal-img"
#   %}
#
# See the documentation for full configuration and usage instructions.
module PictureTag
  # The router module is important. If you're looking for the actual code which
  # handles a `PictureTag.(some method)`, start there.
  extend Router

  ROOT_PATH = __dir__

  # This is the actual liquid tag, which provides the interface with Jekyll.
  class Picture < Liquid::Tag
    # First jekyll initializes our class with a few arguments, of which we only
    # care about the params (arguments passed to the liquid tag). Jekyll makes
    # no attempt to parse them; they're given as a string.
    def initialize(tag_name, raw_params, tokens)
      @raw_params = raw_params
      super
    end

    # Then jekyll calls the 'render' method and passes it a mostly undocumented
    # context object, which appears to hold the entire site including its
    # configuration and the parsed _data dir.
    def render(context)
      setup(context)

      if PictureTag.disabled?
        ''
      else
        PictureTag.output_class.new.to_s
      end
    end

    private

    def setup(context)
      PictureTag.context = context

      # Now that we have both the tag parameters and the context object, we can
      # build our instruction set.
      PictureTag.instructions = Instructions::Set.new(@raw_params)

      # We need to explicitly prevent jekyll from overwriting our generated
      # image files:
      Utils.keep_files
    end
  end
end

Liquid::Template.register_tag('picture', PictureTag::Picture)
