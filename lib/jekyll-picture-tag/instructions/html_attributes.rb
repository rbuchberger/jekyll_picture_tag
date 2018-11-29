module PictureTag
  module Instructions
    # Handles HTML attributes, sourced from configuration and the liquid tag,
    # sent to various elements.
    # Stored as a hash, with string keys.
    class HTMLAttributeSet
      # Initialize with leftovers passed into the liquid tag
      def initialize(params)
        @content = load_preset

        parse_params(params) if params
      end

      def [](key)
        @content[key]
      end

      private

      def load_preset
        PictureTag.preset['attributes'] || {}
      end

      # Syntax this function processes:
      # class="old way" --picture class="new way" --alt Here's my alt text
      def parse_params(params)
        params_array = params.split(/\s+--/).map(&:strip)

        # This allows the old tag syntax to work.
        @content['implicit'] = params_array.shift unless params.strip =~ /^--/

        # Split function above doesn't take the dashes off the first param.
        params_array.first.delete_prefix! '--' if params_array.any?

        params_array.each do |param|
          # Splits on spaces, the first word will be our key.
          a = param.split

          # Supplied tag arguments will overwrite (not append) configured values
          @content[a.shift] = a.join(' ')
        end
      end
    end
  end
end
