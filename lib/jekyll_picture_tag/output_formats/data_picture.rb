module PictureTag
  module OutputFormats
    # picture tag with data-srcsets and such instead of src.
    class DataPicture < Picture
      include DataAttributes
    end
  end
end
