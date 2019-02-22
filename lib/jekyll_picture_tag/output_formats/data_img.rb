module PictureTag
  module OutputFormats
    # img with data-src and such instead of src
    class DataImg < Img
      include DataAttributes
    end
  end
end
