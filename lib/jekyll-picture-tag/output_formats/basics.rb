module PictureTag
  # Contains all possible HTML output format options. Auto is considered its
  # own option.
  module OutputFormats
    # Generic functions common to all output formats.
    module Basics
      include ObjectiveElements

      private

      def build_srcset(media, format)
        if PictureTag.preset['pixel_ratios']
          build_pixel_ratio_srcset(media, format)
        else
          build_width_srcset(media, format)
        end
      end

      def build_pixel_ratio_srcset(media, format)
        Srcsets::PixelRatio.new(media: media, format: format)
      end

      def build_width_srcset(media, format)
        Srcsets::Width.new(media: media, format: format)
      end

      # Used for both the fallback image, and for the complete markup.
      def build_base_img
        img = SingleTag.new 'img'
        attributes = PictureTag.html_attributes

        img.attributes << attributes['img']
        img.attributes << attributes['implicit']

        fallback = build_fallback_image
        img.src = PictureTag.build_url fallback.name

        img.alt = attributes['alt'] if attributes['alt']

        img
      end

      # File, not HTML
      def build_fallback_image
        GeneratedImage.new(
          source_file: PictureTag.source_images[nil],
          format: PictureTag.fallback_format,
          width: PictureTag.fallback_width
        )
      end
    end
  end
end
