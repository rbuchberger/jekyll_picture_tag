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
          raise error_string(format)
        end
      end

      # Returns array of formats that vips can save to
      def vips_formats
        @vips_formats ||= `vips -l filesave`
                          .scan(/\.[a-z\d]{1,6}/)
                          .uniq
                          .map { |format| format.strip.delete_prefix('.') }
      end

      # Returns an array of formats that imagemagick can read & write
      # TODO: Cache this. Currently It costs about .1s per liquid tag.
      def magick_formats
        @magick_formats ||= `convert -list format`
                            .split("\n")
                            .select { |i| i.match? magick_regex }
                            .map { |i| i.split[1].downcase }
      end

      # Returns an array of all known names of a format, for the purposes of
      # parsing supported output formats.
      def all_names(format)
        alts = alternates.select { |a| a.include? format }.flatten
        alts.any? ? alts : [format]
      end

      private

      # Matches these lines:
      #    FLV  MPEG      rw+   Flash Vid(...)
      #   JPEG* JPEG      rw-   Joint Pho(...)
      #
      # But not these lines:
      # Format  Module    Mode  Descripti(...)
      #   -------------------------------(...)
      #   JSON  JSON      -w+   The image(...)
      #    K25  DNG       r--   Kodak Dig(...)
      def magick_regex
        # /^\s*([A-Z\d\-]+\*?\s+){2}rw[+\-]/
        /^\s*[A-Z\d\-]+\*?\s+[A-Z\d\-]+\s+rw[+\-]/
      end

      def error_string(format)
        <<~HEREDOC
          No support for generating #{format} files in this environment!
          Libvips known savers: #{vips_formats.join(', ')}
          Imagemagick known savers:  #{magick_formats.join(', ')}
        HEREDOC
      end

      def alternates
        [%w[jpg jpeg], %w[avif heic heif]]
      end
    end
  end
end
