module PictureTag
  module Srcsets
    # Creates a srcset in the "(filename) (pixel_ratio)x" format.
    # Example: "img.jpg 1x, img2.jpg 1.5x, img3.jpg 2x"
    class PixelRatio
      include Basics

      def to_a
        widths.collect { |w| build_srcset_entry(w) }
      end

      private

      def widths
        target = PictureTag.preset['pixel_ratios'].collect do |p|
          p * PictureTag.preset['base_width']
        end

        check_widths target
      end

      def build_srcset_entry(width)
        # We have to recalculate the pixel ratio after verifying our source
        # image is large enough.
        pixel_ratio = (width.to_f / PictureTag.preset['base_width']).round(2)
        file = generate_file(width)

        "#{PictureTag.build_url(file.name)} #{pixel_ratio}x"
      end
    end
  end
end
