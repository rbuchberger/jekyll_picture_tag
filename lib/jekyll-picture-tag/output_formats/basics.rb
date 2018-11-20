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

      # Checks to ensure file exists.
      def source_image(media_query)
        # Filename relative to source directory:
        image = PictureTag.source_images[media_query]
        # Complete filename:
        filename = File.join(PictureTag.source_dir, image)
        # Only return image if it exists:
        return image if File.exist?(filename)

        warn "Could not find #{filename}."
      end

      # Used for both the fallback image, and for the complete markup.
      def build_base_img
        img = SingleTag.new 'img'

        img.attributes << PictureTag.html_attributes['img']

        img.src = PictureTag.build_url(build_fallback_image.name)

        if PictureTag.html_attributes['alt']
          img.alt = PictureTag.html_attributes['alt']
        end

        img
      end

      # File, not HTML
      def build_fallback_image
        GeneratedImage.new(
          source_file:
            PictureTag::Utils.grab_source_file(PictureTag.source_images[nil]),
          format: PictureTag.fallback_format,
          width: PictureTag.fallback_width
        )
      end
    end
  end
end
