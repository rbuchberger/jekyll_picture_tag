# frozen_string_literal: true

module PictureTag
  module Parsers
    # Global config (big picture). loads jekyll data/config files, and the j-p-t
    # defaults from included yml files.
    class Configuration
      # returns jekyll's configuration (picture is a subset)
      def [](key)
        content[key]
      end

      private

      def content
        @content ||= Utils.deep_merge(DEFAULT_CONFIG, PictureTag.site.config)
      end
    end
  end
end
