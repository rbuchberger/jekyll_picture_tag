# Generated Image
# Represents a generated source file.
class GeneratedImage
  require 'mini_magick'
  require 'fastimage'

  def initialize(source_file:, width:, format:)
    @source = source_file
    @format = format

    @size = build_size(width)

    generate_image unless File.exist? absolute_filename
  end

  def name
    name = @source.base_name
    name << "-#{@size[:width]}by#{@size[:height]}-"
    name << @source.digest
    name << '.' + @format
  end

  def absolute_filename
    @absolute_filename ||= File.join(PictureTag.config.dest_dir, name)
  end

  def width
    @size[:width]
  end

  private

  def build_size(width)
    if width < @source.width
      {
        width: width,
        height: (width / @source.aspect_ratio).round
      }
    else
      @source.size
    end
  end

  def generate_image
    puts 'Generating new image file: ' + name
    image = MiniMagick::Image.open(@source.name)
    # Scale and crop
    image.combine_options do |i|
      i.resize "#{@size[:width]}x#{@size[:height]}^"
      i.strip
    end

    image.format @format

    check_dest_dir

    image.write absolute_filename
  end

  # Make sure destination directory exists
  def check_dest_dir
    dir = File.dirname absolute_filename
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
  end
end
