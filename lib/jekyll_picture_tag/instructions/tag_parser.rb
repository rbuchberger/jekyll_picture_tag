module PictureTag
  module Instructions
    # This tag takes the arguments handed to the liquid tag, and extracts the
    # preset name (if present), source image name(s), and associated media
    # queries (if present). The leftovers (html attributes) are handed off to
    # its respective class.
    class TagParser
      attr_reader :preset_name, :leftovers, :source_names, :media_presets
      def initialize(raw_params)
        @params = build_words PictureTag::Utils.liquid_lookup(raw_params)

        @preset_name = grab_preset_name

        # The first param specified will be our base image, so it has no
        # associated media query.
        @media_presets = []
        @source_names = [] << strip_quotes(@params.shift)

        # Detect and store arguments of the format 'media_query: img.jpg' as
        # keys and values.
        add_media_source while @params.first =~ /[\w\-]+:/
      end

        # Anything left will be html attributes, which is some other classes'
        # problem.
        @leftovers = @params.join(' ')
      end

      private

      def add_media_source
        # There's an extra ':' at the end we need to remove:
        @media_presets << @params.shift[0..-2]
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
      def build_words(raw_params)
        @words = []
        @word = ''
        @in_quotes = false
        @escaped = false

        raw_params.each_char { |c| handle_char(c) }

        add_word
        @words
      end

      def handle_char(char)
        if @escaped
          close_escape char
        elsif char.match(/["\\]/)
          handle_special char
        elsif @in_quotes || char.match(/\S/)
          @word << char
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

        @words << @word
        @word = ''
      end

      def close_escape(char)
        @word << char
        @escaped = false
      end

      def strip_quotes(raw_name)
        raw_name.delete_prefix('"').delete_suffix('"')
      end
    end
  end
end
