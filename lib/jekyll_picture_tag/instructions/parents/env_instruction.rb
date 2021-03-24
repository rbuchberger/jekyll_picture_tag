module PictureTag
  module Instructions
    # There are a few config settings which are environment dependent, and can
    # either be booleans, environment names, or arrays of environment names.
    # This class works it out and returns a boolean.
    class EnvInstruction < Instruction
      private

      def coerce
        get_bool(source)
      end

      def get_bool(value)
        case value
        when true, false, nil then value
        when String then value == PictureTag.jekyll_env
        when Array then value.include? PictureTag.jekyll_env
        when Hash then get_bool(value[:setting])
        else raise ArgumentError, error_message
        end
      end

      def error_message
        "JPT - #{setting_name} must be a boolean, an environment name," \
          ' or an array of environment names.'
      end
    end
  end
end
