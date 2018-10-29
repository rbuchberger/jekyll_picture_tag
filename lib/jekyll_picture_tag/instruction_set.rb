# High level set of instructions for a given tag instance.
class InstructionSet
  attr_reader :source_images, :html_attributes

  def initialize(raw_tag_params, context)
    @context = context

    @settings = defaults.merge(
      site.config['picture'].transform_keys(&:to_sym)
    )

    parse_tag_params raw_tag_params
  end

  def preset_name
    @preset_name || 'default'
  end

  def media_presets
    # Media queries
    site.data['picture']['media-presets']
  end

  def preset
    # Which preset we're using for this tag
    site.data['picture']['markup-presets'][preset_name]
  end

  def output_format
    # Which output format, such as <img> or <picture>
    preset['output_format'] || 'auto'
  end

  # Returns the set of widths to use for a given media query.
  def widths(media)
    width_hash = preset['widths']
    width_hash.default = preset['width']
    width_hash[media]
  end

  def source_dir
    # Site.source is the master jekyll source directory
    # Source dir the jekyll-picture-tag source directory.
    Pathname.join site.source, @settings[:source_dir]
  end

  def dest_dir
    # site.dest is the master jekyll destination directory
    # source_dest is the jekyll-picture-tag destination directory. (generated
    # file location setting.)
    Pathname.join site.dest, @settings[:destination_dir]
  end

  def url_prefix
    # Using pathname, because the URI library doesn't like relative urls.
    Pathname.join site_url, site_path, @settings[:destination_dir]
  end

  def build_url(filename)
    Pathname.join(url_prefix, filename)
  end

  # Allows us to use 'original' as a format name.
  def process_format(format, filename)
    if format.casecmp('original').zero?
      File.extname(filename)[1..-1].downcase # Strip leading period
    else
      format.downcase
    end
  end

  def fallback_format
    process_format(preset['fallback']['format'], source_images[nil])
  end

  def fallback_width
    preset['fallback']['width']
  end

  private

  def parse_tag_params(raw_params)
    # Raw argument example example:
    # [preset] img.jpg [source_key: alt.jpg] [--(element || alt) attr=\"value\"]

    # First, swap out liquid variables and split it on spaces into an array:
    params = liquid_lookup(raw_params, @context).split

    # The preset is the first parameter, unless it's a filename.
    # This regex is really easy to fool. TODO: improve it.
    @preset_name = params.shift unless params.first =~ /[^\s.]+.\w+/

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

    # This gsub allows people to include template code for javascript libraries
    # such as handlebar.js. It adds complication and I'm not sure it has much
    # value now, so I'm commenting it out for now. If someone has a use case for
    # it we can add it back in.
    # .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
  end

  def build_html_attributes(params)
    @html_attributes = preset['attributes'].transform_keys(&:to_sym)
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

  def site
    # Global site data
    @context.registers[:site]
  end

  def site_host
    # site url, example.com
    site.config['url'] || ''
  end

  def site_path
    # example.com/baseurl/
    #            ^^^^^^^^^
    site.config['baseurl'] || ''
  end

  def defaults
    {
      source_dir: '.',
      destination_dir: 'generated',
      markup: 'picture'
    }
  end
end
