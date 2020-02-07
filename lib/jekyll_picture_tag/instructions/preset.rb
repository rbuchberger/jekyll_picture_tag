module PictureTag
  module Instructions
    # Handles the specific tag image set to construct.
    class Preset
      attr_reader :name
      def initialize(name)
        @name = name
        @content = build_preset
      end

      def [](key)
        @content[key]
      end

      def formats
        @content['formats']
      end

      def fallback_format
        @content['fallback_format']
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

      # Image widths to generate for a given media query.
      def widths(media = nil)
        setting_lookup('widths', 'media', media)
      end

      # Image quality setting, possibly dependent on format.
      def quality(format = nil)
        setting_lookup('quality', 'format', format)
      end

      # Gravity setting (for imagemagick cropping)
      def gravity(media = nil)
        setting_lookup('gravity', 'media', media)
      end

      # Crop value
      def crop(media = nil)
        setting_lookup('crop', 'media', media)
      end

      private

      # Return arbitrary setting values, taking their defaults into account.
      # Ex: quality can be set for all image formats, or individually per
      # format. Per-format settings should override the general setting.
      def setting_lookup(setting, prefix, lookup)
        media_values = @content[prefix + '_' + setting] || {}
        media_values.default = @content[setting]

        media_values[lookup]
      end

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
        unless @name == 'default'
          Utils.warning(
            <<~HEREDOC
              Preset "#{@name}" not found in {PictureTag.config['data_dir']}/picture.yml
              under markup_presets key. Using default values."
            HEREDOC
          )
        end

        {}
      end
    end
  end
end
