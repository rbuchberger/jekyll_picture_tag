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
        width_hash = self['media_widths'] || {}
        width_hash.default = self['widths']
        width_hash[media]
      end

      def fallback_format
        PictureTag::Utils.process_format(@content['fallback_format'], nil)
      end

      def fallback_width
        @content['fallback_width']
      end

      # Allows a per-preset hard override of the global nomarkdown setting and
      # JPT's feeble attempts at auto-detection.
      def nomarkdown?
        if @content['nomarkdown'].nil?
          PictureTag.config.nomarkdown?
        else
          @content['nomarkdown']
        end
      end

      private

      def build_preset
        # The _data/picture.yml file is optional.
        picture_data_file = grab_data_file

        default_preset.merge picture_data_file
      end

      def default_preset
        YAML.safe_load File.read(
          File.join(ROOT_PATH, 'jekyll_picture_tag/defaults/presets.yml')
        )
      end

      def grab_data_file
        PictureTag.site
                  .data
                  .dig('picture', 'markup_presets', @name) || no_preset
      end

      def no_preset
        Utils.warning(
          " Preset \"#{@name}\" not found in #{PictureTag.config['data_dir']}/"\
          + 'picture.yml under markup_presets key. Using default values.'
        )

        {}
      end
    end
  end
end
