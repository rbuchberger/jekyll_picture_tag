# Generated Image
module PictureTag
  # Represents a generated source file, to point a srcset at.
  # Properties:
  # source filename, destination filename, size (width or height, accounting
  # for PPI), image format, PPI, source name
  # value
  class GeneratedImage
    attr_reader :source_filename, :source_name, :pixel_ratio, :size

    def initialize(source_filename,
                   source_name,
                   destination_dir,
                   pixel_ratio,
                   size)

      @source_filename = source_filename
      @source_name = source_name
      @destination_dir = destination_dir
      @pixel_ratio = pixel_ratio
      @size = size
    end

    def name
      name = ''
      name << destination_dir + source_filename
      name << '_' + source_name
      name << "_#{ppi}x" unless ppi == 1
      name << '.' + format
      name
    end

    def check_target
      # Make sure target image exists, if not then create it.
    end

    def generate_image
      # Called when image does not exist. Talks to imagemagick
    end
  end
end
