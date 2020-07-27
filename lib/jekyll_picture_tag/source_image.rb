module PictureTag
  # Handles a given source image file and its properties. Provides a speed
  # advantage by storing expensive file reads and writes in instance variables,
  # to be reused by many different generated images.
  class SourceImage
    attr_reader :shortname, :missing, :media_preset

    include MiniMagick

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

    def width
      @width ||= cache[:width] || 999_999
    end

    def height
      @height ||= cache[:height] || 999_999
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
      @ext ||= File.extname(name)[1..-1].downcase
    end

    private

    def cache
      @cache ||= Cache::Source.new(@shortname)
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
      cache[:width] = image.width
      cache[:height] = image.height

      cache.write
    end

    def image
      @image ||= Image.open(name)
    end

    def source_digest
      @source_digest ||= Digest::MD5.hexdigest(File.read(name))
    end

    def missing_image_warning
      "JPT Could not find #{name}. Your site will have broken images. Continuing."
    end

    def missing_image_error
      <<~HEREDOC
        Could not find #{name}. You can force the build to continue anyway by
        setting "picture: ignore_missing_images: true" in "_config.yml".
      HEREDOC
    end
  end
end
