module PictureTag
  module OutputFormats
    # Returns only a srcset attribute, for more custom or complicated markup.
    class NakedSrcset
      include Basics

      def to_s
        build_srcset(nil, PictureTag.preset['formats'].first).to_s
      end
    end
  end
end
