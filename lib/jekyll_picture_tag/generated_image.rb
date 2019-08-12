require 'mini_magick'

module PictureTag
  # Generated Image
  # Represents a generated source file.
  class GeneratedImage
    attr_reader :width, :format
    include MiniMagick

    def initialize(source_file:, width:, format:)
      @source = source_file
      @width  = width
      @format = process_format format

      generate_image unless File.exist?(absolute_filename) || @source.missing
    end

    def name
      "#{@source.base_name}-#{@width}-#{@source.digest}.#{@format}"
    end

    def absolute_filename
      @absolute_filename ||= File.join(PictureTag.dest_dir, name)
    end

    def uri
      ImgURI.new(name).to_s
    end

    private

    def image
      @image ||= Image.open(@source.name)
    end

    def process_image
      image.combine_options do |i|
        i.resize "#{@width}x"
        i.auto_orient
        i.strip
      end

      image.format @format
      image.quality PictureTag.quality(@format)
    end

    def generate_image
      puts 'Generating new image file: ' + name
      process_image
      write_image
    end

    def write_image
      check_dest_dir

      image.write absolute_filename

      FileUtils.chmod(0o644, absolute_filename)
    end

    # Make sure destination directory exists
    def check_dest_dir
      dir = File.dirname absolute_filename
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
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
