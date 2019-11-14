module PictureTag
  module Instructions
    # Handles HTML attributes, sourced from configuration and the liquid tag,
    # sent to various elements.
    # Stored as a hash, with string keys.
    class HTMLAttributeSet
      # Initialize with leftovers passed into the liquid tag. These leftovers
      # (params) take the form of an array of strings, called words, which the
      # tag parser has separated.
      def initialize(params)
        @attributes = load_preset

        parse_params(params) if params
        handle_source_url
      end

      def [](key)
        @attributes[key]
      end

      private

      def load_preset
        # Shamelessly stolen from stackoverflow. Deep cloning a hash is
        # surprisingly tricky! I could pull in ActiveSupport and get
        # Hash#deep_dup, but for now I don't think it's necessary.

        Marshal.load(Marshal.dump(PictureTag.preset['attributes'])) || {}
      end

      # Syntax this function processes:
      # class="old way" --picture class="new way" --alt Here's my alt text
      def parse_params(words)
        key = 'implicit'

        words.each do |word|
          if word.match(/^--/)
            key = word.delete_prefix('--')
          elsif @attributes[key]
            @attributes[key] << ' ' + word
          else
            @attributes[key] = word
          end
        end
      end

      def handle_source_url
        return unless PictureTag.preset['link_source'] && self['link'].nil?

        target = PictureTag.source_images.first.shortname

        @attributes['link'] = ImgURI.new(target, source_image: true).to_s
      end
    end
  end
end
