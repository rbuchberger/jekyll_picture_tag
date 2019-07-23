module PictureTag
  module OutputFormats
    # Returns only a srcset attribute, for more custom or complicated markup.
    class NakedSrcset < Basic
      def to_s
        image = PictureTag.source_images.first
        format = PictureTag.formats.first

        build_srcset(image, format).to_s
      end
    end
  end
end
