require 'ruby-vips'

module PictureTag
  # Represents a generated image file.
  class GeneratedImage
    attr_reader :width, :format

    # include MiniMagick

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
      @image_base = Vips::Image.new_from_file @source.name
    end

    def generate_image
      puts 'Generating new image file: ' + name

      FileUtils.mkdir_p(File.dirname(absolute_filename))
      thumb_init_opts = {}

      if @crop
        thumb_init_opts[:crop] = :attention # from Vips::Interesting
      end

      thumb = Vips::Image.thumbnail @source.name, @width, thumb_init_opts

      thumb_output_opts = {}

      if PictureTag.preset['strip_metadata']
        thumb.autorot
        thumb_output_opts[:strip] = true
      end

      thumb.write_to_file absolute_filename, thumb_output_opts

      FileUtils.chmod(0o644, absolute_filename)
    end

    def quality
      PictureTag.quality(@format, @width)
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
