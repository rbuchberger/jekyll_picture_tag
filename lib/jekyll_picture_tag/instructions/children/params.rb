module PictureTag
  module Instructions
    # Builds instances of all source images.
    class SourceImages < Instruction
      def source
        {
          source_names: PictureTag.params.source_names,
          media_presets: PictureTag.params.media_presets
        }
      end

      def coerce
        sources = [PictureTag::SourceImage.new(source[:source_names].shift)]

        while source[:source_names].any?
          sources << PictureTag::SourceImage.new(
            source[:source_names].shift, source[:media_presets].shift
          )
        end

        sources
      end
    end

    # Which crop to use for a given media query. Can be given either in params
    # or preset.
    class Crop < ConditionalInstruction
      def source
        super.merge(
          { params: PictureTag.params.crop }
        )
      end

      def coerce(media = nil)
        raise ArgumentError unless valid?

        source[:params][media] || value_hash[media]
      end

      def setting_basename
        'crop'
      end

      def setting_prefix
        'media'
      end

      def acceptable_types
        super + [String]
      end
    end

    # Which vips interestingness setting to use for a given media query. Can be
    # given either in params or preset.
    class Keep < ConditionalInstruction
      def source
        super.merge(
          { params: PictureTag.params.keep }
        )
      end

      def coerce(media = nil)
        raise ArgumentError unless valid?

        lookup[source[:params][media] || super(media)]
      end

      def lookup
        {
          'center' => :centre,
          'centre' => :centre,
          'attention' => :attention,
          'entropy' => :entropy
        }
      end

      def setting_basename
        'keep'
      end

      def setting_prefix
        'media'
      end

      def acceptable_types
        super + [String]
      end
    end
  end
end
