module PictureTag
  # Handles a given source image file and its properties. Provides a speed
  # advantage by storing expensive file reads and writes in instance variables,
  # to be reused by many different generated images.
  class SourceImage
    attr_reader :shortname, :missing, :media_preset

    # include MiniMagick

    def initialize(relative_filename, media_preset = nil)
      # /home/dave/my_blog/assets/images/somefolder/myimage.jpg
      #                                  ^^^^^^^^^^^^^^^^^^^^^^
      @shortname = relative_filename
      @media_preset = media_preset

      @missing = missing?
      check_cache
    end

    def digest
      @digest ||= cache[:digest] || ''
    end

    def crop
      PictureTag.crop(media_preset)
    end

    def crop?
      !crop.nil?
    end

    def keep
      PictureTag.keep(media_preset)
    end

    def dimensions
      [width, height]
    end

    def width
      return raw_width unless crop?

      [raw_width, (raw_height * cropped_aspect)].min.round
    end

    def height
      return raw_height unless crop?

      [raw_height, (raw_width / cropped_aspect)].min.round
    end

    def cropped_aspect
      return Utils.aspect_float(raw_width, raw_height) unless crop?

      Utils.aspect_float(*crop.split(':').map(&:to_f))
    end

    # /home/dave/my_blog/assets/images/somefolder/myimage.jpg
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def name
      @name ||= File.join(PictureTag.source_dir, @shortname)
    end

    # /home/dave/my_blog/assets/images/somefolder/myimage.jpg
    #                                  ^^^^^^^^^^^^^^^^^^
    def base_name
      @shortname.delete_suffix File.extname(@shortname)
    end

    # /home/dave/my_blog/assets/images/somefolder/myimage.jpg
    #                                                     ^^^
    def ext
      @ext ||= File.extname(name)[1..].downcase
    end

    private

    # pre-crop
    def raw_width
      @raw_width ||= @missing ? 999_999 : image.width
    end

    # pre-crop
    def raw_height
      @raw_height ||= @missing ? 999_999 : image.height
    end

    def cache
      @cache ||= Cache.new(@shortname)
    end

    def missing?
      if File.exist? name
        false

      elsif PictureTag.continue_on_missing?
        Utils.warning(missing_image_warning)
        true

      else
        raise ArgumentError, missing_image_error
      end
    end

    def check_cache
      return if @missing
      return if cache[:digest] && PictureTag.fast_build?

      update_cache if source_digest != cache[:digest]
    end

    def update_cache
      cache[:digest] = source_digest

      cache.write
    end

    def image
      @image ||= Vips::Image.new_from_file(name)
    end

    def source_digest
      @source_digest ||= Digest::MD5.hexdigest(File.read(name))
    end

    def missing_image_warning
      "JPT Could not find #{name}. " \
        'Your site will have broken images. Continuing.'
    end

    def missing_image_error
      <<~HEREDOC
        Could not find #{name}. You can force the build to continue anyway by
        setting "picture: ignore_missing_images: true" in "_config.yml".
      HEREDOC
    end
  end
end
