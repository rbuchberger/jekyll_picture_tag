require 'yaml'
# High level set of instructions for a given tag instance.
class InstructionSet
  attr_reader :config, :preset, :params

  def initialize(raw_tag_params, context)
    @context = context

    site_config = site.config['picture'] || {}

    @settings = defaults.merge(
      site_config.transform_keys(&:to_sym)
    )

    parse_tag_params raw_tag_params
  end

  def build_global_settings
    default_config.merge @context.registers[:site]
  end

  def build_preset
    if site.data['picture']
      default_preset.merge site.data['picture'][preset_name]
    else
      default_preset
    end
  end

  # Returns the set of widths to use for a given media query.
  def widths(media)
    width_hash = preset['widths'] || {}
    width_hash.default = preset['width']
    width_hash[media]
  end

  def source_dir
    # Site.source is the master jekyll source directory
    # Source dir the jekyll-picture-tag source directory.
    File.join site.source, @settings[:source_dir]
  end

  def dest_dir
    # site.dest is the master jekyll destination directory
    # source_dest is the jekyll-picture-tag destination directory. (generated
    # file location setting.)
    File.join site.dest, @settings[:destination_dir]
  end

  def url_prefix
    # Using pathname, because the URI library doesn't like relative urls.
    File.join site_url, site_path, @settings[:destination_dir]
  end

  def build_url(filename)
    File.join url_prefix, filename
  end

  # Allows us to use 'original' as a format name.
  def process_format(format, _media)
    if format.casecmp('original').zero?
      filename = source_images[filename]
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

  def site
    # Global site data
    @context.registers[:site]
  end

  private

  def default_config
    Yaml.load File.read(__dir__ + '/defaults/global.yml')
  end

  def default_preset
    Yaml.load File.read(__dir__ + '/defaults/preset.yml')
  end
end
