module PictureTag
  module OutputFormats
    # This is an odd class, which never returns itself. It selects the most
    # appropriate format, and returns an instance of that class.
    class Auto
      def self.new
        if PictureTag::Utils.count_srcsets > 1
          Picture.new
        else
          Img.new
        end
      end
    end
  end
end
