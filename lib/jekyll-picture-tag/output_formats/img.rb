module PictureTag
  module OutputFormats
    # Represents a bare <img> tag with a srcset attribute.
    # Used when <picture> is unnecessary.
    class Img
      include PictureTag::OutputFormats::Basics

      def srcset
        build_srcset(nil, PictureTag.preset['formats'].first)
      end

      def to_s
        img = build_base_img
        img.srcset = srcset.to_s
        img.sizes = srcset.sizes if srcset.sizes

        if PictureTag.html_attributes['implicit']
          img.attributes << PictureTag.html_attributes['implicit']
        end

        img.to_s
      end
    end
  end
end
