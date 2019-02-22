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
        source_image_names = { nil => @params.shift }

        # Store source keys which fit a pattern in a hash.
        while @params.first =~ /[\w\-]+:/
          media_query = @params.shift[0..-2]
          source_image_names[media_query] = @params.shift
        end

        @source_images = build_sources(source_image_names)

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

      # Takes filenames relative to JPT source directory. SourceImage instances
      # persist within a tag, allowing us to only perform some expensive File
      # operations once.
      def build_sources(names)
        names.transform_values { |n| PictureTag::SourceImage.new n }
      end
    end
  end
end
