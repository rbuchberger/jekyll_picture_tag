module PictureTag
  # Handles a given source image file and its properties. Provides a speed
  # advantage by storing expensive file reads and writes in instance variables,
  # to be reused by many different source images.
  class SourceImage
    attr_reader :name, :shortname, :missing

    def initialize(relative_filename)
      @shortname = relative_filename
      @name = grab_file relative_filename
    end

    def size
      @size ||= build_size
    end

    def width
      size[:width]
    end

    def digest
      @digest ||= if @missing
                    'x' * 6
                  else
                    Digest::MD5.hexdigest(File.read(@name))[0..5]
                  end
    end

    # Includes path relative to default sorce folder, and the original filename.
    def base_name
      @shortname.delete_suffix File.extname(@shortname)
    end

    # File exention
    def ext
      # [1..-1] will strip the leading period.
      @ext ||= File.extname(@name)[1..-1].downcase
    end

    private

    def build_size
      if @missing
        width = 999_999
        height = 999_999
      else
        width, height = FastImage.size(@name)
      end

      {
        width: width,
        height: height
      }
    end

    # Turn a relative filename into an absolute one, and make sure it exists.
    def grab_file(source_file)
      source_name = File.join(PictureTag.config.source_dir, source_file)

      if File.exist? source_name
        @missing = false

      elsif PictureTag.config.continue_on_missing?
        @missing = true
        Utils.warning missing_image_warning(source_name)

      else
        raise missing_image_error(source_name)
      end

      source_name
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
