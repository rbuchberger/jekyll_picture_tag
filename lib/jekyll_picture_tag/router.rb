module PictureTag
  # The rest of the application doesn't care where the instruction logic
  # resides. This module 'routes' method calls to the right place, so
  # information consumers can just call 'PictureTag.(some method)'
  #
  # This is accomplished with a bit of metaprogramming, which is hopefully not
  # unnecessarily clever or complicated. Missing methods are converted to class
  # names, which are looked up under the Instructions module namespace.
  #
  # Instantiated Instructions are stored in a hash, keyed by method name.
  module Router
    # These two attributes encompass everything passed in by Jekyll.
    attr_accessor :raw_params, :context

    def method_missing(method_name, *args)
      if instruction_exists?(method_name)
        instruction(method_name).value(*args)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *args)
      instruction_exists?(method_name) || super
    end

    # Required at least for testing; instructions are persisted between tags
    # otherwise.
    def clear_instructions
      instructions.clear
    end

    private

    def instruction(method_name)
      instructions[method_name] ||= instruction_class(method_name).new
    end

    def instructions
      @instructions ||= {}
    end

    def instruction_exists?(method_name)
      Object.const_defined? instruction_class_name(method_name.to_sym)
    end

    # Class names can't contain question marks, so we strip them.
    def instruction_class(method_name)
      Object.const_get instruction_class_name(method_name)
    end

    def instruction_class_name(method_name)
      'PictureTag::Instructions::' +
        Utils.titleize(method_name.to_s.delete_suffix('?'))
    end
  end
end
