module PictureTag
  module OutputFormats
    # Allows us to create JavaScript Library friendly markup, for things like
    # LazyLoad
    module DataAttributes
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
    end
  end
end
