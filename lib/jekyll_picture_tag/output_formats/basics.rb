module PictureTag
  # Contains all possible HTML output format options. Auto is considered its
  # own option.
  module OutputFormats
    # Generic functions common to all output formats.
    module Basics
      include ObjectiveElements

      # Used for both the fallback image, and for the complete markup.
      def build_base_img
        img = SingleTag.new 'img'
        attributes = PictureTag.html_attributes

        img.attributes << attributes['img']
        img.attributes << attributes['implicit']

        fallback = build_fallback_image

        add_src(img, fallback.name)

        add_alt(img, attributes['alt'])

        img
      end

      def to_s
        wrap(base_markup).to_s
      end

      private

      # Handles various wrappers around basic markup
      def wrap(markup)
        if PictureTag.html_attributes['link']
          markup = anchor_tag(markup)
          markup = nomarkdown_wrapper(markup.to_s) if PictureTag.nomarkdown?
        end

        markup
      end

      # Media is the media query associated with the desired source image.
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

      # Extracting these functions to their own methods for easy overriding.
      # They are destructive.
      def add_src(element, name)
        element.src = PictureTag.build_url name
      end

      def add_srcset(element, srcset)
        element.srcset = srcset.to_s
      end

      def add_sizes(element, srcset)
        element.sizes = srcset.sizes if srcset.sizes
      end

      def add_alt(element, alt)
        element.alt = alt if alt
      end

      def add_media(element, srcset)
        element.media = srcset.media_attribute if srcset.media
      end

      # File, not HTML
      def build_fallback_image
        GeneratedImage.new(
          source_file: PictureTag.source_images[nil],
          format: PictureTag.fallback_format,
          width: PictureTag.fallback_width
        )
      end

      # Stops kramdown from molesting our output
      # Must be given a string.
      #
      # Kramdown is super picky about the {::nomarkdown} extension-- we have to
      # strip line breaks or nothing works.
      def nomarkdown_wrapper(content)
        "{::nomarkdown}#{content.delete("\n")}{:/nomarkdown}"
      end

      def anchor_tag(content)
        anchor = DoubleTag.new 'a'
        anchor.attributes << PictureTag.html_attributes['a']
        anchor.href = PictureTag.html_attributes['link']

        content.add_parent anchor
      end
    end
  end
end
