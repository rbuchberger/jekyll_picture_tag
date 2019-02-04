module PictureTag
  module OutputFormats
    # This is not an output format, it's a module for use in others. It allows
    # us to create JavaScript Library friendly markup, for things like LazyLoad
    module DataAttributes
      def to_s
        super + build_noscript
      end

      private

      def add_src(element, name)
        element.attributes << { 'data-src' => PictureTag.build_url(name) }
      end

      def add_srcset(element, srcset)
        element.attributes << { 'data-srcset' => srcset.to_s }
      end

      def add_sizes(element, srcset)
        element.attributes << { 'data-sizes' => srcset.sizes } if srcset.sizes
      end

      def build_noscript
        return '' unless PictureTag.preset['noscript']

        "\n" + DoubleTag.new(
          'noscript',
          content: Img.new.build_base_img
        ).to_s
      end
    end
  end
end
