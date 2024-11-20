module PictureTag
  module Parsers
    # Tag Parsing Responsibilities:
    #
    #  {% picture mypreset a.jpg 3:2 mobile: b.jpg --alt "Alt" --link "/" %}
    # |  Jekyll  |           TagParser            |    HTMLAttributes    |
    #
    # This class takes the arguments handed to the liquid tag (given as a simple
    # string), hands them to ArgSplitter (which breaks them up into an array of
    # words), extracts the preset name (if present), source image name(s),
    # associated media queries (if present), and image-related arguments such as
    # crop and keep. HTML attributes are handed off to its respective class
    # (as 'leftovers')
    #
    # Media presets and source names are stored as arrays in their correct
    # orders. Crop settings are stored in a hash, keyed by their
    # relevant media presets. Note that the base image will have a media preset
    # of nil, which is a perfectly fine hash key.
    class TagParser
      attr_reader :preset_name, :source_names, :media_presets, :keep,
                  :crop, :leftovers, :css_class

      def initialize(raw_params)
        @raw_params = raw_params
        @params = split_params

        @media_presets = []
        @source_names = []
        @keep = {}
        @crop = {}
        @css_class = ""

        parse_params
      end

      private

      def split_params
        ArgSplitter
          .new(Utils.liquid_lookup(@raw_params))
          .words
      end

      def parse_params
        @preset_name = determine_preset_name
        @source_names << strip_quotes(@params.shift)

        parse_param(@params.first) until stop_here? @params.first

        @leftovers = @params
      end

      def parse_param(param)
        # Media query, i.e. 'mobile:'
        if param.match?(/[\w\-]+:$/)
          add_media_source

        # class for css
        elsif param == "css"
          @params.shift
          @css_class = @params.shift

        # Smartcrop interestingness setting. We label it 'keep', since it
        # determines what to keep when cropping.
        elsif %w[none centre center entropy attention].include?(param.downcase)
          @keep[@media_presets.last] = @params.shift

        # Aspect ratio, i.e. '16:9'
        elsif param.match?(/\A\d+:\d+\z/)
          @crop[@media_presets.last] = @params.shift

        else
          raise_error(param)
        end
      end

      # HTML attributes are handled by its own class; once we encounter them
      # we are finished here.
      def stop_here?(param)
        # No param    Explicit HTML attribute   Implicit HTML attribute
        param.nil? || param.match?(/^--\S*/) || param.match?(/^\w*="/)
      end

      def add_media_source
        @media_presets << @params.shift.delete_suffix(':')
        @source_names << strip_quotes(@params.shift)
      end

      # The first param is the preset name, unless it's a filename.
      def determine_preset_name
        @params.first.include?('.') ? 'default' : @params.shift
      end

      def strip_quotes(name)
        name.delete_prefix('"').delete_suffix('"')
      end

      def raise_error(param)
        raise ArgumentError, "Could not parse '#{param}' in the following "\
          "tag: \n  {% picture #{@raw_params} %}"
      end
    end
  end
end
