module PictureTag
  module OutputFormats
    # Represents a <picture> tag, enclosing at least 2 <source> tags and an
    # <img> tag.
    class Picture
      include Basics
      def build_srcsets
        sets = []

        @instructions.preset.formats.each do |format|
          # Source images are defined by their media queries:
          @instructions.source_images.each_key do |media|
            sets << build_srcset(media, format)
          end
        end

        # Media queries are given from most to least restrictive, but the markup
        # requires them the other way around:
        sets.reverse
      end

      def build_picture
        DoubleTag.new(
          element: 'picture',
          attributes: instructions.attributes[:picture],
          content: build_sources << build_base_img
        )
      end

      def build_sources
        srcsets.collect { |s| build_source(s) }
      end

      def build_source(srcset)
        source = SingleTag.new('source',
                               attributes: @instructions.attributes[:source])

        # Sizes will be the same for all sources. There's some redundant markup
        # here, but I don't think it's worth the effort to prevent.
        source.sizes = srcset.sizes if srcset.sizes

        # The srcset has an associated media query, which might be nil. Don't
        # apply it if that's the case:
        source.media = srcset.media if srcset.media

        source.type = srcset.mime_type

        source.srcset = srcset.to_s
        source
      end
    end
  end
end
