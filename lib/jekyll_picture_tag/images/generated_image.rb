require 'ruby-vips'

module PictureTag
  # Represents a generated image, but not the file itself. Its purpose is to
  # make its properties available for query, and hand them off to the ImageFile
  # class for generation.
  class GeneratedImage
    attr_reader :width

    def initialize(source_file:, width:, format:, crop: nil, gravity: '')
      @source = source_file
      @width  = width
      @raw_format = format
      @crop = crop
      @gravity = gravity
    end

    def format
      @format ||= process_format(@raw_format)
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

    # https://example.com/assets/somefolder/myimage-100-123abc.jpg
    #                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
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

    def quality
      PictureTag.quality(format, width)
    end

    private

    # We exclude width and format from the cache name, since it isn't specific
    # to them.
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

    # Hash all inputs and truncate, so we know when they change without getting
    # too long.
    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-1234abcde.jpg
    #                                                           ^^^^^^^^^
    def id
      @id ||= Digest::MD5.hexdigest([@source.digest, @crop, @gravity,
                                     quality].join)[0..8]
    end

    def image
      return @image if defined? @image

      # Post crop, before resizing and reformatting
      @source_dimensions = { width: image_base.width,
                             height: image_base.height }

      @image = image_base
    end

    def image_base
      @image_base ||= Vips::Image.new_from_file @source.name
    end

    def generate_image
      ImageFile.new(@source, self)
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
