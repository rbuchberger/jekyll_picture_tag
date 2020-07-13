module PictureTag
  module Cache
    # Caches generated image details, so we can skip expensive operations whenever
    # possible.
    # Stored width and height are values for the source image, after cropping.
    class Generated
      include Base

      private

      def cache_dir
        'generated'
      end

      def template
        { width: nil, height: nil }
      end
    end
  end
end
