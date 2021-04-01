module PictureTag
  module Parsers
    # Returns information regarding image handlers
    class ImageBackend
      def handler_for(format)
        if (vips_formats & all_names(format)).any?
          :vips
        elsif (magick_formats & all_names(format)).any?
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

      # Returns an array of all known names of a format, for the purposes of
      # parsing supported output formats.
      def all_names(format)
        alts = alternates.select { |a| a.include? format }.flatten
        alts.any? ? alts : [format]
      end

      private

      def alternates
        [%w[jpg jpeg], %w[avif heic heif]]
      end
    end
  end
end
