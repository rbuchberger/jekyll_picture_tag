module PictureTag
  # Basically a wrapper class for vips. Handles image operations.
  # Vips returns new images for Crop, resize, and autorotate operations.
  # Quality, metadata stripping, and format are applied on write.
  #
  # This deserves to be two classes and a factory, one for normal vips save and
  # one for magicksave. This is illustrated by the fact that stubbing backend
  # determination logic for its unit tests would basically require
  # re-implementing it completely.
  #
  # I'm planning to implement standalone imagemagick as an alternative to vips,
  # so when I add that I'll also do that refactoring. For now it works fine and
  # it's not too bloated.
  class ImageFile
    def initialize(source, base)
      @source = source
      @base = base

      build
    end

    private

    attr_reader :source, :base

    def build
      notify

      mkdir

      image = load_image

      image = process(image)

      write(image)
    end

    # Processing pipeline
    def process(image)
      image = crop(image) if source.crop?

      image = resize(image)

      image.autorot
    end

    def handler
      PictureTag.backend.handler_for(@base.format)
    end

    def quality_key
      handler == :vips ? :Q : :quality
    end

    def write_opts
      opts = PictureTag.preset['image_options'][@base.format] || {}

      opts[:strip] = PictureTag.preset['strip_metadata']

      # gifs don't accept a quality setting, and PNGs don't on older versions of
      # vips. Since it's not remarkably useful anyway, we'll ignore them.
      opts[quality_key] = base.quality unless %w[gif png].include? base.format

      opts.transform_keys(&:to_sym)
    end

    def load_image
      Vips::Image.new_from_file source.name
    end

    def write(image)
      case handler
      when :vips
        image.write_to_file(base.absolute_filename, **write_opts)
        # If vips can't handle it, fall back to imagemagick.
      when :magick
        image.magicksave(base.absolute_filename, **write_opts)
      end

      # Fix permissions. TODO - still necessary?
      FileUtils.chmod(0o644, base.absolute_filename)
    end

    def notify
      puts 'Generating new image file: ' + base.name
    end

    def resize(image)
      image.resize(scale_value)
    end

    def crop(image)
      image.smartcrop(*source.dimensions,
                      interesting: PictureTag.keep(@source.media_preset))
    end

    def scale_value
      base.width.to_f / source.width
    end

    def mkdir
      FileUtils.mkdir_p(File.dirname(base.absolute_filename))
    end
  end
end
