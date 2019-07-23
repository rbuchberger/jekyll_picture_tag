module PictureTag
  module Instructions
    # This tag takes the arguments handed to the liquid tag, and extracts the
    # preset name (if present), source image name(s), and associated media
    # queries (if present). The leftovers (html attributes) are handed off to
    # its respective class.
    class TagParser
      attr_reader :preset_name, :leftovers, :source_names
      def initialize(raw_params)
        @params = PictureTag::Utils.liquid_lookup(raw_params).split

        @preset_name = grab_preset_name

        # source_names keys are media queries, values are source images. The
        # first param specified will be our base image, so it has no associated
        # media query. Yes, nil can be a hash key.
        @source_names = { nil => @params.shift }

        # Detect and store arguments of the format 'media_query: img.jpg' as
        # keys and values.
        while @params.first =~ /[\w\-]+:/
          media_query = @params.shift[0..-2]
          image_filename = @params.shift

          @source_names[media_query] = image_filename
        end

        # Anything left will be html attributes, which is some other classes
        # problem.
        @leftovers = @params.join(' ')
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
