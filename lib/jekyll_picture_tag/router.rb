module PictureTag
  # The rest of the application doesn't care where the instruction logic
  # resides. The following module 'routes' method calls to the right place, so
  # the rest of the application can just call 'PictureTag.(some method)'

  # At first I thought I'd do some sweet dynamic metaprogramming here, but it
  # ended up complicated and clever, rather than convenient and understandable.
  # This way is not strictly DRY, but it's straightforward and readable. If it
  # gets big, I'll refactor.
  module Router
    attr_accessor :instructions, :context
    # Context forwarding

    # Global site data
    def site
      @context.registers[:site]
    end

    # Page which tag is called from
    def page
      @context.registers[:page]
    end

    # Instructions forwarding

    def config
      @instructions.config
    end

    def preset
      @instructions.preset
    end

    def media_presets
      @instructions.media_presets
    end

    def html_attributes
      @instructions.html_attributes
    end

    def output_class
      @instructions.output_class
    end

    def source_images
      @instructions.source_images
    end

    def crop(media = nil)
      @instructions.crop(media)
    end

    def gravity(media = nil)
      @instructions.gravity(media)
    end

    # Config Forwarding

    def source_dir
      config.source_dir
    end

    def dest_dir
      config.dest_dir
    end

    def continue_on_missing?
      config.continue_on_missing?
    end

    def cdn?
      config.cdn?
    end

    def pconfig
      config.pconfig
    end

    def disabled?
      config.disabled?
    end

    def fast_build?
      config.fast_build?
    end

    # Preset forwarding

    def widths(media)
      preset.widths(media)
    end

    def formats
      preset.formats
    end

    def fallback_format
      preset.fallback_format
    end

    def fallback_width
      preset.fallback_width
    end

    def nomarkdown?
      preset.nomarkdown?
    end

    def quality(format)
      preset.quality(format)
    end
  end
end
