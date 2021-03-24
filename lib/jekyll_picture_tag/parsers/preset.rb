module PictureTag
  module Parsers
    # Handles the specific tag image set to construct.
    class Preset
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def [](key)
        content[key]
      end

      protected

      def content
        @content ||= DEFAULT_PRESET.merge settings
      end

      private

      def settings
        PictureTag.site.data.dig('picture', 'presets', name) ||
          STOCK_PRESETS[name] ||
          no_preset
      end

      def no_preset
        unless name == 'default'
          Utils.warning(
            <<~HEREDOC
              Preset "#{name}" not found in #{PictureTag.config['data_dir']}/picture.yml
              under 'presets' key, or in stock presets. Using default values."
            HEREDOC
          )
        end

        {}
      end
    end
  end
end
