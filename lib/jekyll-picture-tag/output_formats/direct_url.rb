module PictureTag
  module OutputFormats
    # Represents a bare url you can use in another context, such as a direct link, but keep the resizing functionality
    class DirectUrl
      include PictureTag::OutputFormats::Basics

      def to_s
        build_base_img.attributes.content[:src].first rescue ""
      end
    end
  end
end
