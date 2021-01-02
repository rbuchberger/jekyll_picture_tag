module PictureTag
  module OutputFormats
    # This is not an output format, it's a module for use in others. It allows
    # us to create JavaScript Library friendly markup, for things like LazyLoad
    module DataAttributes
      def base_markup
        build_noscript(super)
      end

      private


      def foo
        @srcset ||= build_srcset(
          PictureTag.source_images.first, PictureTag.formats.first
        )
      end

      def add_src(element, uri)
        element.attributes << { src: "data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 "+foo.width_attribute+" "+foo.height_attribute+"\'%3E%3C/svg%3E", 'data-src' => uri }
      end

      def placeholder
        <<~PLACEHOLDER
          "data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 "+foo.width_attribute+" "+foo.height_attribute+"\'%3E%3C/svg%3E"
        PLACEHOLDER
      end

      def add_srcset(element, srcset)
        element.attributes << { 'data-srcset' => srcset.to_s }
      end

      def add_sizes(element, srcset)
        return unless srcset.sizes

        attribute = PictureTag.preset['data_sizes'] ? 'data-sizes' : 'sizes'
        element.attributes << { attribute => srcset.sizes }
      end

      def build_noscript(base_content)
        return base_content unless PictureTag.preset['noscript']

        noscript = DoubleTag.new(
          'noscript',
          content: Img.new.build_base_img,

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        ).to_s

        ShelfTag.new(
          content: [base_content, noscript],

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        )
      end
    end
  end
end
