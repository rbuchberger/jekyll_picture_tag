module PictureTag
  module Instructions
    # Handles the specific tag image set to construct.
    class Preset
      attr_reader :name
      def initialize
        @name = PictureTag.preset_name
        @content = build_preset
      end

      def [](key)
        @content[key]
      end

      # Returns the set of widths to use for a given media query.
      def widths(media)
        width_hash = self['widths'] || {}
        width_hash.default = self['width']
        width_hash[media]
      end

      def fallback_format
        PictureTag::Utils.process_format(@content['fallback']['format'], nil)
      end

      def fallback_width
        @content['fallback']['width']
      end

      private

      def build_preset
        # The _data/picture.yml file is optional.
        if PictureTag.site.data['picture']['markup_presets']
          default_preset.merge(
            PictureTag.site.data['picture']['markup_presets'][@name]
          )
        else
          default_preset
        end
      end

      def default_preset
        YAML.safe_load File.read(
          File.join(ROOT_PATH, 'jekyll-picture-tag/defaults/presets.yml')
        )
      end
    end
  end
end
