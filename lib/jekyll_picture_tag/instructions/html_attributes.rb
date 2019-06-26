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
        handle_url
      end

      def [](key)
        @content[key]
      end

      private

      def load_preset
        PictureTag.preset['attributes'].dup || {}
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
      # Handles anchor tag destination. Can come from 2 places in 2 formats:
      # Can come from defaults, preset, or tag
      # Default is false. Preset can specify either true or false
      # Tag params can be a URL

      # picture test.jpg --url http://example.com
      def handle_url
        return unless PictureTag.preset['link_source'] && !self['link']

        @content['link'] = PictureTag.build_source_url(
          Utils.biggest_source.shortname
        )
      end
    end
  end
end
