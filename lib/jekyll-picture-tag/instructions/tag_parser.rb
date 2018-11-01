module PictureTag
  module Instructions
    # This class takes the string given to the jekyll tag, and extracts useful
    # information from it.
    class TagParser
      def initialize(raw_params, context)
        @raw_params = raw_params
        @context = context
      end

      def parse_tag_params(raw_params)
        # Raw argument example example:
        # [preset] img.jpg [source_key: alt.jpg] [--(element || alt) attr=\"value\"]

        # First, swap out liquid variables and split it on spaces into an array:
        params = liquid_lookup(raw_params).split

        # The preset is the first parameter, unless it's a filename.
        # This regex is really easy to fool. TODO: improve it.
        @preset_name = params.shift unless params.first =~ /[^\s.]+.\w+/

        # This is the only hardcoded default value. I'm not making and loading a
        # yml file just for one value.
        @preset_name ||= 'default' 

        # source_image keys are media queries, values are source images. The first
        # param specified will be our base image, so it has no associated media
        # query.
        @source_images = { nil => params.shift }

        # Check if the next param is a source key, and if so assign it to the
        # local variable source_key.
        while params.first =~ /(?<media_query>\w+):/
          params.shift # throw away the param, we already have the key
          @source_images[media_query] = params.shift
        end

        # Anything left will be html attributes
        build_html_attributes params.join(' ')
      end

      def liquid_lookup(params)
        Liquid::Template.parse(params).render(@context)

        # This gsub allows people to include template code for javascript
        # libraries such as handlebar.js. It adds complication and I'm not sure
        # it has much value now, so I'm commenting it out. If someone has a use
        # case for it we can add it back in.
        # .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
      end

      def build_html_attributes(params)
        preset_attributes = preset['attributes'] || {}
        @html_attributes = preset_attributes.transform_keys(&:to_sym)
        # Example input:
        # --picture class="awesome" --alt stumpy --img data-attribute="value"
        params.split(' --').map(&:strip).each do |param|
          # ['picture class="awesome"', 'alt stumpy', 'img data-attribute="value"']

          # Splits on spaces, the first word will be our key.
          a = param.split

          # Supplied tag arguments will overwrite (not append) configured values
          @html_attributes[a.shift.to_sym] = a.join(' ')
        end
      end
    end
  end
end
