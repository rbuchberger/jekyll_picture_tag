module PictureTag
  module OutputFormats
    # Represents a <picture> tag, enclosing at least 2 <source> tags and an
    # <img> tag.
    class Picture
      include Basics

      def srcsets
        sets = []

        PictureTag.preset['formats'].each do |format|
          # We have 2 dimensions here: formats, and source images. Formats are
          # provided in the order they must be returned, source images are
          # provided in the reverse (least to most preferable) and must be
          # flipped. We'll use an intermediate value to accomplish this.
          format_set = []

          # Source images are defined in the tag params, and associated with
          # media queries. The base (first provided) image has a key of nil.
          PictureTag.source_images.each_key do |media|
            format_set << build_srcset(media, format)
          end
          sets.concat format_set.reverse
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
