# High level set of instructions. This class does all the decision making.
class InstructionSet
  attr_reader :context, :source_images
  def initialize(raw_tag_params, context)
    @context = context

    @settings = defaults.merge(
      site.config['picture'].transform_keys(&:to_sym)
    )
    parse_tag_params raw_tag_params
  end

  def parse_tag_params(raw_params)
    # Raw argument example example:
    # [preset] img.jpg [source_key: alt-img.jpg] [attr=\"value\"]

    # First, swap out liquid variables and split it on spaces into an array:
    params = liquid_lookup(raw_params, @context).split

    # The preset is the first parameter, unless it's a filename.
    # This regex is really easy to fool; Will improve later.
    @preset_name = params.shift unless params.first =~ /[^\s.]+.\w+/

    # The next parameter will be the image source. We set it as the default, so
    # when we lookup values that aren't specifically set it will be returned.
    @source_images = Hash.new(params.shift)

    # Check if the next param is a source key, and if so assign it to the
    # local variable source_key.
    while params.first =~ /(?<source_key>\w+):/
      params.shift # throw away the param, we already have the key
      @source_images[source_key] = params.shift
    end

    # Anything left will be html attributes
    parse_html_attributes params
  end

  def liquid_lookup(params, context)
    # Render any liquid variables in tag arguments and unescape template code
    Liquid::Template.parse(params)
                    .render(context)
                    .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
  end

  def parse_html_attributes(params)
    # Dealing with custom attributes, as well as the alt text
  end

  # Convenience methods:

  # Allows us to access things like source_dir by instructions.source_dir
  def method_missing(method)
    @settings[method] || super
  end

  def respond_to_missing?(method)
    @settings.key?(method) || super
  end

  def site
    # Global site data
    context.registers[:site]
  end

  def presets
    # Read presets from _data/picture.yml
    site.data['picture']
  end

  def preset
    # Which preset we're using for this tag
    presets[preset_name]
  end

  def url
    # site url, example.com/
    site.config['url'] || ''
  end

  def baseurl
    # example.com/baseurl/
    site.config['baseurl'] || ''
  end

  def preset_name
    @preset_name || 'default'
  end

  def defaults
    {
      source_dir: '.',
      output_dir: 'generated',
      markup: 'picture'
    }
  end
end
