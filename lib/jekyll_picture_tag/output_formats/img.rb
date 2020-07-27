module PictureTag
  module OutputFormats
    # Represents a bare <img> tag with a srcset attribute.
    # Used when <picture> is unnecessary.
    class Img < Basic
      private

      def srcset
        @srcset ||= build_srcset(
          PictureTag.source_images.first, PictureTag.formats.first
        )
      end

      def base_markup
        img = build_base_img

        add_srcset(img, srcset)
        add_sizes(img, srcset)

        img.attributes << PictureTag.html_attributes['parent']

        add_dimensions(img, srcset)

        img
      end

      def add_dimensions(img, srcset)
        return unless PictureTag.preset['dimension_attributes']

        img.width = srcset.width_attribute
        img.height = srcset.height_attribute
      end
    end
  end
end
