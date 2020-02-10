module PictureTag
  module Instructions
    # Supervisor class, which manages all input handling and high level decision
    # making which depends on it.
    class Set
      def initialize(raw_tag_params)
        @raw_tag_params = raw_tag_params
      end

      def config
        @config ||= Configuration.new
      end

      def params
        @params ||= TagParser.new @raw_tag_params
      end

      def preset
        @preset ||= Preset.new params.preset_name
      end

      def html_attributes
        # Depends on both the preset and tag params.
        @html_attributes ||= HTMLAttributeSet.new params.leftovers
      end

      # These are our Media Query presets. It's really just a hash, and there
      # are no default values, so extracting this to its own class is overkill.
      def media_presets
        PictureTag.site.data.dig('picture', 'media_presets') || {}
      end

      def source_images
        @source_images ||= build_source_images
      end

      def crop(media = nil)
        params.geometries[media] || preset.crop(media)
      end

      def gravity(media = nil)
        params.gravities[media] || preset.gravity(media)
      end

      # Returns a class constant for the selected output format, which is used
      # to dynamically instantiate it.
      def output_class
        Object.const_get(
          'PictureTag::OutputFormats::' + Utils.titleize(preset['markup'])
        )
      end

      private

      def build_source_images
        source_names = params.source_names
        media_presets = params.media_presets

        sources = [SourceImage.new(source_names.shift)]

        while params.source_names.any?
          sources << SourceImage.new(
            source_names.shift, media_presets.shift
          )
        end

        sources
      end
    end
  end
end
