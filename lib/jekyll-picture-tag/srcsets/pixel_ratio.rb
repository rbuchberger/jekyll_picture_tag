module PictureTag
  module Srcsets
    # Creates a srcset in the "(filename) (pixel_ratio)x" format.
    class PixelRatio
      include Basics

      def to_a
        pixel_ratios.collect { |p| build_srcset_entry(p) }
      end

      private

      def build_srcset_entry(pixel_ratio)
        width = base_width * pixel_ratio
        file = generate_file(width)

        "#{@instructions.build_url(file.name)} #{pixel_ratio}x"
      end

      def pixel_ratios
        @instructions.preset['pixel_ratios']
      end

      def base_width
        @instructions.preset['base_width']
      end
    end
  end
end
