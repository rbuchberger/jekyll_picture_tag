module PictureTag
  # Contains all possible HTML output format options. Auto is considered its
  # own option.
  module OutputFormats
    # Generic functions common to all output formats.
    module Basics
      include ObjectiveElements

      private

      def build_srcset(media, format)
        if PictureTag.config.preset['pixel_ratios']
          build_pixel_ratio_srcset(media, format)
        else
          build_width_srcset(media, format)
        end
      end

      def build_pixel_ratio_srcset(media, format)
        Srcsets::PixelRatio.new(media: media, format: format,
                                instructions: @instructions)
      end

      def build_width_srcset(media, format)
        Srcsets::Width.new(media: media, format: format,
                           instructions: @instructions)
      end

      # Checks to ensure file exists.
      def source_image(media_query)
        # Filename relative to source directory:
        image = PictureTag.config.source_images[media_query]
        # Complete filename:
        filename = File.join(PictureTag.config.source_dir, image)
        # Only return image if it exists:
        return image if File.exist?(filename)

        raise "Could not find #{filename}"
      end

      def generate_file(image, format, width)
        GeneratedImage.new(
          source_image: image,
          output_dir: PictureTag.config.dest_dir,
          width: width,
          format: format
        )
      end

      # Used for both the fallback image, and for the complete markup.
      def build_base_img
        img = SingleTag.new 'img'
        config = PictureTag.config

        img.attributes << config.html_attributes['img']

        img.src = config.build_url(build_fallback_image.name)

        img.alt = config.html_attributes['alt'] if config.html_attributes['alt']

        img
      end

      # File, not HTML
      def build_fallback_image
        GeneratedImage.new(
          source_dir: PictureTag.config.source_dir,
          source_file: PictureTag.config.source_images[nil],
          format: PictureTag.config.fallback_format,
          width: PictureTag.config.fallback_width,
          output_dir: PictureTag.config.dest_dir
        )
      end
    end
  end
end
