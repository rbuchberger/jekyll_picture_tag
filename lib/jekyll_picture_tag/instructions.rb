module PictureTag
  # Instructions obtain, validate, and typecast/coerce input values. These
  # inputs are either taken directly from jekyll's inputs, or handled by parsers
  # first.
  #
  # Logic which affects only a single setting belongs in Instructions, while
  # logic which affects multiple settings belongs in Parsers.
  #
  # Since instruction classes are so small, we define several per file in the
  # instructions directory to save on boilerplate. All fall under the
  # Instructions module namespace.
  module Instructions
    # Generic instruction, meant to be inherited. Children of this class must
    # override the source method, and likely want to override valid?, coerce,
    # and error_message as applicable.
    class Instruction
      # Memoized value of the given instruction. This is the public API.
      def value
        return @value if defined?(@value)

        raise ArgumentError, error_message unless valid?

        @value = coerced
      end

      private

      # Source(s) of truth - where does this setting come from? Logic does not
      # belong here. If information comes from muliple places, return an array
      # or a hash.
      def source
        raise NotImplementedError
      end

      # Determine whether or not the input(s) are valid.
      def valid?
        true
      end

      # Convert input(s) to output.
      def coerce
        source
      end

      # Message returned if validation fails. Override this with something more
      # helpful.
      def error_message
        "JPT - #{setting_name} received an invalid argument: #{source}"
      end

      def coerced
        return @coerced if defined?(@coerced)

        @coerced = coerce
      end

      def setting_name
        Utils.snakeize(self.class.to_s.split('::').last)
      end
    end
  end
end

# Load Parents
Dir[File.dirname(__FILE__) + '/instructions/parents/*.rb']
  .sort.each { |file| require file }

# Load children:
Dir[File.dirname(__FILE__) + '/instructions/children/*.rb']
  .sort.each { |file| require file }
