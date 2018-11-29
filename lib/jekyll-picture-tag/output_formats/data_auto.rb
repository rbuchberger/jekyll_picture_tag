module PictureTag
  module OutputFormats
    # Similar to Auto, but sets data-src (and so on) instead of src
    class DataAuto < Auto
      def self.new
        if PictureTag::Utils.count_srcsets > 1
          DataPicture.new
        else
          DataImg.new
        end
      end
    end
  end
end
