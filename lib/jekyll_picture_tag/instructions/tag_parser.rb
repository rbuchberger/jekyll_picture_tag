module PictureTag
  module Instructions
    # This tag takes the arguments handed to the liquid tag, and extracts the
    # preset name (if present), source image name(s), and associated media
    # queries (if present). The leftovers (html attributes) are handed off to
    # its respective class.
    class TagParser
      attr_reader :preset_name, :source_names, :media_presets
      def initialize(raw_params)
        build_params PictureTag::Utils.liquid_lookup(raw_params)

        @preset_name = grab_preset_name

        # The first param specified will be our base image, so it has no
        # associated media query.
        @media_presets = []
        @source_names = [] << strip_quotes(@params.shift)

        # Detect and store arguments of the format 'media_query: img.jpg' as
        # keys and values.
        add_media_source while @params.first =~ /[\w\-]+:$/
      end

      def leftovers
        @params
      end

      private

      def add_media_source
        @media_presets << @params.shift.delete_suffix(':')
        @source_names << strip_quotes(@params.shift)
      end

      # First param is the preset name, unless it's a filename.
      def grab_preset_name
        if @params.first.include? '.'
          'default'
        else
          @params.shift
        end
      end

      # Originally separating arguments was just handled by splitting the raw
      # params on spaces. To handle quotes and backslash escaping, we have to
      # parse the string by characters to break it up correctly. I'm sure
      # there's a library to do this, but it's not that much code honestly. If
      # this starts getting big, we'll pull in a new dependency.
      def build_params(raw_params)
        @params = []
        @word = ''
        @in_quotes = false
        @escaped = false

        raw_params.each_char { |c| handle_char(c) }

        add_word # We have to explicitly add the last one.
      end

      def handle_char(char)
        # last character was a backslash:
        if @escaped
          close_escape char

        # char is a backslash or a quote:
        elsif char.match(/["\\]/)
          handle_special char

        # Character isn't whitespace, or it's inside double quotes:
        elsif @in_quotes || char.match(/\S/)
          @word << char

        # Character is whitespace outside of double quotes:
        else
          add_word
        end
      end

      def handle_special(char)
        if char == '\\'
          @escaped = true
        elsif char == '"'
          @in_quotes = !@in_quotes
          @word << char
        end
      end

      def add_word
        return if @word.empty?

        @params << @word
        @word = ''
      end

      def close_escape(char)
        @word << char
        @escaped = false
      end

      def strip_quotes(name)
        name.delete_prefix('"').delete_suffix('"')
      end
    end
  end
end
