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
        picture_data_file = grab_data_file

        default_preset.merge picture_data_file
      end

      def default_preset
        YAML.safe_load File.read(
          File.join(ROOT_PATH, 'jekyll-picture-tag/defaults/presets.yml')
        )
      end

      def grab_data_file
        if PictureTag.site.data['picture'] &&
           PictureTag.site.data['picture']['markup_presets'] &&
           PictureTag.site.data['picture']['markup_presets'][@name]

          PictureTag.site.data['picture']['markup_presets'][@name]
        else
          warn 'Jekyll Picture Tag Warning:'.yellow +
               " Preset \"#{@name}\" not found in _data/picture.yml under "\
               'markup_presets key. Using default values.'
          {}
        end
      end
    end
  end
end
