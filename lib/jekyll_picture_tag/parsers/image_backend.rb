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
        if command?('vips')
          @vips_formats ||= `vips -l`
                            .split('/n')
                            .select { |line| line.include? 'ForeignSave' }
                            .flat_map { |line| line.scan(/\.[a-z]{1,5}/) }
                            .map { |format| format.strip.delete_prefix('.') }
                            .uniq
        else
          @vips_formats = []
        end
      end

      # Returns an array of formats that imagemagick can handle.
      def magick_formats
        if command?('magick')
          @magick_formats ||= `magick -version`
                              .scan(/Delegates.*/)
                              .first
                              .delete_prefix('Delegates (built-in):')
                              .split
        elsif command?('convert')
          @magick_formats ||= `convert -version`
                              .scan(/Delegates.*/)
                              .first
                              .delete_prefix('Delegates (built-in):')
                              .split
        else
          @magick_formats = []
        end
      end

      # Returns an array of all known names of a format, for the purposes of
      # parsing supported output formats.
      def all_names(format)
        alts = alternates.select { |a| a.include? format }.flatten
        alts.any? ? alts : [format]
      end

      private

      def error_string(format)
        str = []
        str << "No support for generating \"#{format}\" files in this environment!"
        str << if command?('vips')
                 "Libvips (installed) supports: \"#{vips_formats.join(', ')}\"."
               else
                 'Libvips is not installed.'
               end
        str << if command?('magick') || command?('convert')
                 "Imagemagick (installed) supports: \"#{magick_formats.join(', ')}\"."
               else
                 'Imagemagick is not installed.'
               end
        str.join(' ')
      end

      def alternates
        [%w[jpg jpeg], %w[avif heic heif]]
      end

      def command?(command)
        is_windows = RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
        if is_windows
          system("where #{command} > NUL 2>&1")
        else
          system("which #{command} > /dev/null 2>&1")
        end
      end
    end
  end
end
