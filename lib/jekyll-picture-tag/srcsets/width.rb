module PictureTag
  module Srcsets
    # Creates a srcset in the "(filename) (width)w, (...)" format.
    # Example: "img.jpg 400w, img2.jpg 600w, img3.jpg 800w"
    class Width
      include Basics

      def to_a
        widths.collect { |w| build_srcset_entry(w) }
      end

      # Sizes html attribute. Since it's intimately related to srcset, we
      # generate it at the same time.
      def sizes
        return nil unless PictureTag.preset['sizes']

        sizes = []
        PictureTag.preset['sizes'].each_pair do |media, size|
          sizes << build_size_entry(media, size)
        end

        sizes << PictureTag.preset['size']

        sizes.join ', '
      end

      private

      def widths
        PictureTag.widths(@media)
      end

      def build_srcset_entry(width)
        file = generate_file(width)

        "#{PictureTag.build_url(file.name)} #{file.width}w"
      end

      def build_size_entry(media, size)
        "(#{PictureTag.media_presets[media]}) #{size}"
      end
    end
  end
end
