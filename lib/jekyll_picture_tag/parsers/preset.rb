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
        @content ||= begin
          content = settings
          parents = [content["inherit"]].flatten.compact.map do |base|
            PictureTag.site.data.dig('picture', 'presets', base) || no_preset(base)
          end
          parents.reduce DEFAULT_PRESET.merge(content) do |child, parent|
            Jekyll::Utils.deep_merge_hashes(parent, child)
          end
        end
      end

      private

      def settings
        PictureTag.site.data.dig('picture', 'presets', name) ||
          STOCK_PRESETS[name] ||
          no_preset
      end

      def default_preset
        return DEFAULT_PRESET if name == 'default'
        @default ||= DEFAULT_PRESET.merge( PictureTag.site.data.dig('picture', 'presets', 'default') || {})
      end

      def no_preset(name=@name)
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
