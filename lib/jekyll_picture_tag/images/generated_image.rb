require 'mini_magick'

module PictureTag
  # Represents a generated image file.
  class GeneratedImage
    attr_reader :width, :format

    include MiniMagick

    def initialize(source_file:, width:, format:, crop: nil, gravity: '')
      @source = source_file
      @width  = width
      @format = process_format format
      @crop = crop
      @gravity = gravity
    end

    def exists?
      File.exist?(absolute_filename)
    end

    def generate
      generate_image unless @source.missing || exists?
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def absolute_filename
      @absolute_filename ||= File.join(PictureTag.dest_dir, name)
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    #                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def name
      @name ||= "#{@source.base_name}-#{@width}-#{id}.#{@format}"
    end

    # https://example.com/assets/images/myimage-100-123abc.jpg
    #                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def uri
      ImgURI.new(name).to_s
    end

    # Post crop
    def source_width
      update_cache unless cache[:width]

      cache[:width]
    end

    # Post crop
    def source_height
      update_cache unless cache[:height]

      cache[:height]
    end

    private

    # We exclude width and format from the cache name, since it isn't specific to them.
    def cache
      @cache ||= Cache::Generated.new("#{@source.base_name}-#{id}")
    end

    def update_cache
      return if @source.missing

      # Ensure it's generated:
      image

      cache[:width] = @source_dimensions[:width]
      cache[:height] = @source_dimensions[:height]

      cache.write
    end

    # Hash all inputs and truncate, so we know when they change without getting too long.
    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-1234abcde.jpg
    #                                                           ^^^^^^^^^
    def id
      @id ||= Digest::MD5.hexdigest([@source.digest, @crop, @gravity, quality].join)[0..8]
    end

    # Post crop, before resizing and reformatting
    def image
      @image ||= open_image
    end

    def open_image
      image_base = Image.open(@source.name)
      image_base.combine_options do |i|
        i.auto_orient
        if @crop
          i.gravity @gravity
          i.crop @crop
        end
      end

      @source_dimensions = { width: image_base.width, height: image_base.height }

      image_base
    end

    def generate_image
      puts 'Generating new image file: ' + name
      process_image
      write_image
    end

    def quality
      PictureTag.quality(@format)
    end

    def process_image
      image.combine_options do |i|
        i.resize "#{@width}x"
        i.strip
      end

      image.format @format
      image.quality quality
    end

    def write_image
      FileUtils.mkdir_p(File.dirname(absolute_filename))

      image.write absolute_filename

      FileUtils.chmod(0o644, absolute_filename)
    end

    def process_format(format)
      if format.casecmp('original').zero?
        @source.ext
      else
        format.downcase
      end
    end
  end
end
