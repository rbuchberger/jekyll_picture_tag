module PictureTag
  module Instructions
    # Many inputs take a common format: a generic setting which applies all of
    # the time, or more specific versions of that setting for specific
    # circumstances. For example, quality can be set globally, or per image
    # format. This instruction class handles those cases.
    #
    # To use, you must at minimum define setting_basename, setting_prefix, and
    # add to the acceptable_types (or write your own validation).
    class ConditionalInstruction < Instruction
      def value(*args)
        coerce(*args)
      end

      private

      def setting_basename
        raise NotImplementedError
      end

      # Special condition for setting; media, crop, etc
      def setting_prefix
        raise NotImplementedError
      end

      def acceptable_types
        [NilClass]
      end

      def coerce(arg)
        raise ArgumentError unless valid?

        value_hash[arg]
      end

      def source
        {
          hash: PictureTag.preset[setting_prefix + '_' + setting_name],
          default: PictureTag.preset[setting_name]
        }
      end

      def value_hash
        vals = source[:hash] || {}
        vals.default = source[:default]

        vals
      end

      def valid?
        valid_hash? && valid_default?
      end

      def acceptable_type?(value)
        acceptable_types.any? { |type| value.is_a? type }
      end

      def valid_hash?
        source[:hash].nil? || source[:hash].values.all? do |v|
          acceptable_type?(v)
        end
      end

      def valid_default?
        acceptable_type? source[:default]
      end
    end
  end
end
