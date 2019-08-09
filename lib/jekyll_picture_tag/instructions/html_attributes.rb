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
        handle_source_url
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
      def parse_params(words)
        key = 'implicit'

        words.each do |word|
          if word.match(/^--/)
            key = word.delete_prefix('--')
          elsif @content[key]
            @content[key] << ' ' + word
          else
            @content[key] = word
          end
        end
      end

      def handle_source_url
        return unless PictureTag.preset['link_source'] && self['link'].nil?

        target = PictureTag.source_images.first.shortname

        @content['link'] = ImgURI.new(target, source_image: true).to_s
      end
    end
  end
end
