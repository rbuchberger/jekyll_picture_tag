module PictureTag
  module Srcsets
    # Creates a srcset in the "(filename) (pixel_ratio)x" format.
    # Example: "img.jpg 1x, img2.jpg 1.5x, img3.jpg 2x"
    class PixelRatio
      include Basics

      def to_a
        PictureTag.preset['pixel_ratios'].collect do |p|
          build_srcset_entry(p)
        end
      end

      private

      def build_srcset_entry(pixel_ratio)
        width = PictureTag.preset['base_width'] * pixel_ratio
        file = generate_file(width)

        "#{PictureTag.config.build_url(file.name)} #{pixel_ratio}x"
      end
    end
  end
end
