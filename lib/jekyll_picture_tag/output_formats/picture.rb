module PictureTag
  module OutputFormats
    # Represents a <picture> tag, enclosing at least 2 <source> tags and an
    # <img> tag.
    class Picture < Basic
      private

      def srcsets
        @srcsets ||= build_srcsets
      end

      def build_srcsets
        formats = PictureTag.formats
        # Source images are provided in reverse order and must be flipped:
        images = PictureTag.source_images.reverse
        sets = []

        formats.each do |format|
          images.each { |image| sets << build_srcset(image, format) }
        end

        sets
      end

      def build_sources
        srcsets.collect { |s| build_source(s) }
      end

      def build_source(srcset)
        source = SingleTag.new(
          'source',
          attributes: PictureTag.html_attributes['source']
        )

        # Sizes will be the same for all sources. There's some redundant markup
        # here, but I don't think it's worth the effort to prevent.
        add_sizes(source, srcset)
        add_media(source, srcset)
        add_srcset(source, srcset)

        source.type = srcset.mime_type

        source
      end

      def build_base_img
        img = super

        # Only add source dimensions if there is a single source image.
        # Currently you can't use both art direction and intrinsic image sizes.
        if PictureTag.preset['dimension_attributes'] &&
           PictureTag.source_images.length == 1
          img.attributes << {
            width: srcsets.first.width_attribute,
            height: srcsets.first.height_attribute
          }
        end

        img
      end

      def base_markup
        picture = DoubleTag.new(
          'picture',
          attributes: PictureTag.html_attributes['picture'],
          content: build_sources << build_base_img,

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        )

        picture.attributes << PictureTag.html_attributes['parent']

        picture
      end
    end
  end
end
