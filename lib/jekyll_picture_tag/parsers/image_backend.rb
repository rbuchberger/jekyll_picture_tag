module PictureTag
  module Parsers
    # Returns information regarding image handlers
    class ImageBackend
      def handler_for(format)
        if vips_formats.include? format
          :vips
        elsif magick_formats.include? format
          :magick
        else
          raise "No support for generating #{format} files in this environment."
        end
      end

      # Returns array of formats that vips can save to
      def vips_formats
        @vips_formats ||= `vips -l filesave`
                          .scan(/\.[a-z]{1,5}/)
                          .uniq
                          .map { |format| format.strip.delete_prefix('.') }
      end

      # Returns an array of formats that imagemagick can handle.
      def magick_formats
        @magick_formats ||= `convert -version`
                            .split("\n")
                            .last
                            .delete_prefix('Delegates (built-in):')
                            .split
      end
    end
  end
end
