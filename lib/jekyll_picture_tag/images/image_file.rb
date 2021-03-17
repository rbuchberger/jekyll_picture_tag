module PictureTag
  # Basically a wrapper class for vips. Handles image operations.
  # Vips returns new images for Crop, resize, and autorotate operations.
  # Quality, metadata stripping, and format are applied on write.
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

    def write_opts
      opts = PictureTag.preset['image_options'][@base.format] || {}

      opts[:strip] = PictureTag.preset['strip_metadata']

      # gifs don't accept a quality setting.
      opts[:Q] = base.quality unless base.format == 'gif'

      opts.transform_keys(&:to_sym)
    end

    def load_image
      Vips::Image.new_from_file source.name
    end

    def write(image)
      begin
        image.write_to_file(base.absolute_filename, **write_opts)
      rescue Vips::Error
        # If vips can't handle it, fall back to imagemagick.
        binding.pry unless @base.format == 'jp2'
        opts = write_opts.transform_keys do |key|
          key == :Q ? :quality : key
        end

        image.magicksave(base.absolute_filename, **opts)
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
