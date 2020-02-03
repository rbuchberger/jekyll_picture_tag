module PictureTag
  module Srcsets
    # Creates a srcset in the "(filename) (pixel_ratio)x" format.
    # Example: "img.jpg 1x, img2.jpg 1.5x, img3.jpg 2x"
    class PixelRatio < Basic
      private

      def widths
        PictureTag.preset['pixel_ratios'].collect do |p|
          p * PictureTag.preset['base_width']
        end
      end

      def build_srcset_entry(file)
        # We have to recalculate the pixel ratio after verifying our source
        # image is large enough.
        pixel_ratio = (
          file.width.to_f / PictureTag.preset['base_width']
        ).round(2)

        "#{file.uri} #{pixel_ratio}x"
      end
    end
  end
end
