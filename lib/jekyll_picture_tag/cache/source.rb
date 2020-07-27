module PictureTag
  module Cache
    # Caches source image details, so we can skip expensive operations whenever
    # possible.
    class Source
      include Base

      private

      def template
        { digest: nil, width: nil, height: nil }
      end

      def cache_dir
        'source'
      end
    end
  end
end
