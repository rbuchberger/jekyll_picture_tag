require 'mime-types'

module PictureTag
  module Instructions
    # Returns an instance of the correct markup format's corresponding class
    class OutputClass < Instruction
      private

      def source
        PictureTag.preset['markup']
      end

      def coerce
        Object.const_get(class_name)
      end

      def class_name
        'PictureTag::OutputFormats::' + Utils.titleize(source)
      end

      def valid?
        source.is_a?(String) &&
          !source.include?(' ') &&
          Object.const_defined?(class_name)
      end
    end

    # Image formats
    class Formats < Instruction
      private

      def source
        PictureTag.preset['formats']
      end

      def coerce
        [source].flatten
      end

      def valid?
        coerced.all? do |format|
          types = MIME::Types.type_for(format)
          format == 'original' ||
            types.length == 1 && types.first.media_type == 'image'
        end
      end
    end

    # Fallback image format
    class FallbackFormat < Instruction
      private

      def source
        PictureTag.preset['fallback_format']
      end

      def valid?
        types = MIME::Types.type_for(coerced)
        coerced == 'original' ||
          types.length == 1 && types.first.media_type == 'image'
      end
    end

    # Fallback Image width
    class FallbackWidth < Instruction
      private

      def source
        PictureTag.preset['fallback_width']
      end

      def valid?
        source.is_a? Integer
      end

      def error_message
        <<~HEREDOC
          fallback_width for preset '#{PictureTag.preset.name}' is invalid. It
          should be a positive integer. You can use underscores as separators:
            1200
            1_200
        HEREDOC
      end
    end

    # Whether to add a {::nomarkdown} wrapper
    class Nomarkdown < Instruction
      private

      def source
        {
          config: PictureTag.pconfig['nomarkdown'],
          md_page: Utils.markdown_page?,
          preset: PictureTag.preset['nomarkdown']
        }
      end

      def valid?
        source.fetch_values(:preset, :config).all? do |setting|
          [true, false, nil].include? setting
        end
      end

      def coerce
        return source[:preset] unless source[:preset].nil?

        source[:md_page] && source[:config]
      end
    end

    # Returns widths for a given media query.
    class Widths < ConditionalInstruction
      private

      def setting_name
        'widths'
      end

      def setting_prefix
        'media'
      end

      def acceptable_types
        super + [Array]
      end

      def valid_hash?
        hash = source[:hash]
        return true if hash.nil?

        hash.is_a?(Hash) && valid_hash_keys?(hash) && valid_hash_values?(hash)
      end

      def valid_hash_keys?(hash)
        hash.keys.all? { |k| k.is_a? String }
      end

      def valid_hash_values?(hash)
        hash.values.all? do |val|
          val.is_a?(Array) && val.all? { |subval| subval.is_a? Integer }
        end
      end
    end

    # Returns quality for a given width.
    class Quality < ConditionalInstruction
      private

      def setting_name
        'quality'
      end

      def setting_prefix
        'format'
      end

      def acceptable_types
        super + [Integer, Hash]
      end

      def coerce(format = nil, width = nil)
        setting = super(format)

        return setting unless setting.is_a? Hash

        parse_quality_hash(setting, width)
      end

      # Works out linearly interpolated quality settings.
      def parse_quality_hash(points, width)
        # The points can be given in any order.
        low, high = *points.keys.map(&:to_i).sort

        case width
        when 0..low then points[low]
        when low..high then Utils.interpolate(points.keys, points.values, width)
        when high..999_999 then points[high]
        end
      end
    end
  end
end
