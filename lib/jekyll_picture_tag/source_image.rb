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
    end

    def width
      @width ||= if @missing
                   999_999
                 else
                   image.width
                 end
    end

    def digest
      @digest ||= if @missing
                    'x' * 6
                  else
                    Digest::MD5.hexdigest(File.read(@name))[0..5]
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

    def image
      @image ||= Image.open(@name)
    end

    # Turn a relative filename into an absolute one, and make sure it exists.
    def grab_file(source_file)
      source_name = File.join(PictureTag.source_dir, source_file)

      if File.exist? source_name
        @missing = false
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

    end

    def missing_image_warning(source_name)
      <<~HEREDOC
        Could not find #{source_name}. Your site will have broken images in it.
        Continuing.
      HEREDOC
    end

    def missing_image_error(source_name)
      <<~HEREDOC
        Jekyll Picture Tag could not find #{source_name}. You can force the
        build to continue anyway by setting "picture: ignore_missing_images:
        true" in "_config.yml". This setting can also accept a jekyll build
        environment, or an array of environments.
      HEREDOC
    end
  end
end
