module PictureTag
  module Instructions
    # This class takes the string given to the jekyll tag, and extracts useful
    # information from it.
    class TagParser
      attr_reader :preset_name, :source_images, :html_attributes_raw
      def initialize(raw_params)
        @params = PictureTag::Utils.liquid_lookup(raw_params).split

        @preset_name = grab_preset_name

        # source_image keys are media queries, values are source images. The
        # first param specified will be our base image, so it has no associated
        # media query. Yes, nil can be a hash key.
        @source_images = { nil => @params.shift }

        # Check if the next param is a source key, and if so assign it to a
        # local variable.
        while @params.first =~ /[\w\-]+:/
          media_query = @params.shift[0..-2]
          @source_images[media_query] = @params.shift
        end

        # Anything left will be html attributes
        @html_attributes_raw = @params.join(' ')
      end

      private

      # First param is the preset name, unless it's a filename.
      def grab_preset_name
        if @params.first =~ %r{[\w./]+\.\w+}
          'default'
        else
          @params.shift
        end
      end
    end
  end
end
