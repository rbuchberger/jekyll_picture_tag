module PictureTag
  module Instructions
    # This class takes in the arguments passed to the liquid tag, and splits it
    # up into 'words' (correctly handling quotes and backslash escapes.)
    #
    # To handle quotes and backslash escaping, we have to parse the string by
    # characters to break it up correctly. I'm sure there's a library to do
    # this, but it's not that much code honestly. If this starts getting big,
    # we'll pull in a new dependency.
    #
    class ArgSplitter
      attr_reader :words

      def initialize(raw_params)
        @words = []
        @word = ''
        @in_quotes = false
        @escaped = false

        raw_params.each_char { |c| handle_char(c) }

        add_word # We have to explicitly add the last one.
      end

      private

      def handle_char(char)
        # last character was a backslash:
        if @escaped
          close_escape char

        # char is a backslash or a quote:
        elsif char.match?(/["\\]/)
          handle_special char

        # Character isn't whitespace, or it's inside double quotes:
        elsif @in_quotes || char.match(/\S/)
          @word << char

        # Character is whitespace outside of double quotes:
        else
          add_word
        end
      end

      def add_word
        return if @word.empty?

        @words << @word
        @word = ''
      end

      def handle_special(char)
        if char == '\\'
          @escaped = true
        elsif char == '"'
          @in_quotes = !@in_quotes
          @word << char
        end
      end

      def close_escape(char)
        @word << char
        @escaped = false
      end
    end
  end
end
