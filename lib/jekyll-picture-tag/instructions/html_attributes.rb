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
        if params.include? '--'
          parse_current_syntax params
        else
          parse_old_syntax params
        end
      end

      def parse_current_syntax(params)
        params_array = params.split(' --').map(&:strip)

        # If for some reason a person uses a mix of the old and new style, this
        # will handle it.
        parse_legacy params_array.shift unless params.strip =~ /^--/

        # Split function above doesn't take the dashes off the first param.
        params_array.first.delete_prefix! '--'

        params_array.each do |param|
          # Splits on spaces, the first word will be our key.
          a = param.split

          # Supplied tag arguments will overwrite (not append) configured values
          @content[a.shift] = a.join(' ')
        end
      end

      def parse_old_syntax(params)
        # Pull out alt text if it's there.
        @content['alt'] = alt_text if params =~ /alt="(?<alt_text>\w+)"/

        # Everything else goes to the parent element.
        @content['implicit'] =
          params.gsub(/alt="\w+"/, '')
                .gsub('  ', ' ') # Pulling out alt text may leave a double space
                .strip
      end
    end
  end
end
