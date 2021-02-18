module PictureTag
  module Parsers
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
        search_data('presets') || search_data('markup_presets') || no_preset
      end

      def search_data(key)
        PictureTag.site
                  .data
                  .dig('picture', key, name)
      end

      def no_preset
        unless name == 'default'
          Utils.warning(
            <<~HEREDOC
              Preset "#{name}" not found in {PictureTag.config['data_dir']}/picture.yml
              under markup_presets key. Using default values."
            HEREDOC
          )
        end

        {}
      end
    end
  end
end
