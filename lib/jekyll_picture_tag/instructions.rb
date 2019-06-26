require_relative './instructions/configuration'
require_relative './instructions/html_attributes'
require_relative './instructions/preset'
require_relative './instructions/tag_parser'

# Allows us to access settings as methods on PictureTag itself.
module PictureTag
  class << self
    attr_reader :context, :config, :params, :preset, :html_attributes

    def init(raw_tag_params, context)
      @context = context

      # Create global config (big picture). Config class loads jekyll
      # data/config files, and the j-p-t defaults from included yml files.
      @config = Instructions::Configuration.new

      # Parse tag params. We must do this before setting the preset, because
      # it's one of the params.
      @params = Instructions::TagParser.new(raw_tag_params)

      # Create preset. Takes preset name from params, merges associated settings
      # with default values.
      @preset = Instructions::Preset.new

      # Create HTML attributes. Depends on both the preset and tag params, so
      # we must do this after creating both.
      @html_attributes = Instructions::HTMLAttributeSet.new(
        @params.html_attributes_raw
      )

      # Keep our generated files
      Utils.keep_files
    end

    # Global site data
    def site
      @context.registers[:site]
    end

    # Page which tag is called from
    def page
      @context.registers[:page]
    end

    # Media query presets. It's really just a hash, and there are no default
    # values, so extracting it to its own class is overkill.
    def media_presets
      site.data.dig('picture', 'media_presets') || {}
    end

    # The rest of the application doesn't care where the instruction logic
    # resides. For example, I don't want to use PictureTag.config.source_dir and
    # PictureTag.params.source_images, I just want to use PictureTag.source_dir
    # and PictureTag.source_images. The following method definitions accomplish
    # that.

    # At first I thought I'd do some sweet dynamic metaprogramming here, but it
    # ended up more complicated and clever than convenient. This way is not
    # strictly DRY, but it's understandable and readable.

    # Config Forwarding
    def source_dir
      @config.source_dir
    end

    def dest_dir
      @config.dest_dir
    end

    def build_url(filename)
      @config.build_url(filename)
    end

    def build_source_url(filename)
      @config.build_source_url(filename)
    end

    # Preset forwarding
    def widths(media)
      @preset.widths(media)
    end

    def fallback_format
      @preset.fallback_format
    end

    def fallback_width
      @preset.fallback_width
    end

    def nomarkdown?
      @preset.nomarkdown?
    end


    # Params forwarding
    def preset_name
      @params.preset_name
    end

    def source_images
      @params.source_images
    end
  end
end
