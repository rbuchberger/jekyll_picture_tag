# Generated Image
# Represents a generated source file.
class GeneratedImage
  require 'mini_magick'
  require 'fastimage'

  attr_reader :width

  def initialize(source_file:, width:, format:)
    @source = source_file
    @width  = width
    @format = format

    generate_image unless File.exist?(absolute_filename) || @source.missing
  end

  def name
    name = @source.base_name
    name << "-#{@width}-"
    name << @source.digest
    name << '.' + @format
  end

  def absolute_filename
    @absolute_filename ||= File.join(PictureTag.config.dest_dir, name)
  end

  private

  def generate_image
    puts 'Generating new image file: ' + name
    image = MiniMagick::Image.open(@source.name)
    # Scale and crop
    image.combine_options do |i|
      i.resize "#{@width}x"
      i.auto_orient
      i.strip
    end

    image.format @format

    check_dest_dir

    image.write absolute_filename

    FileUtils.chmod(0o644, absolute_filename)
  end

  # Make sure destination directory exists
  def check_dest_dir
    dir = File.dirname absolute_filename
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
  end
end
