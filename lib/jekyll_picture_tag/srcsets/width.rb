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
        preset_sizes = PictureTag.preset['sizes'] || {}
        preset_size = PictureTag.preset['size']
        size_set = []

        preset_sizes.each_pair do |media, size|
          size_set << build_size_entry(media, size)
        end

        size_set << preset_size if preset_size

        size_set.any? ? size_set.join(', ') : nil
      end

      private

      def widths
        check_widths PictureTag.widths(@media)
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
