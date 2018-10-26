# Generated Image
# Represents a generated source file.
class GeneratedImage
  require 'fileutils'
  require 'pathname'
  require 'digest/md5'
  require 'mini_magick'
  require 'fastimage'

  def initialize(source_dir:, source_file:, output_dir:, width:, format:)
    @source_dir = source_dir
    @output_dir = output_dir
    @source_file = File.join(source_dir, source_file)
    @format = format

    # Base name will be prepended to generated filename.
    # Includes path relative to default sorce folder, and the original filename.
    @base_name = source_file.delete_suffix File.extname source_file

    # If the destination directory doesn't exist, create it
    FileUtils.mkdir_p(@output_dir) unless Pathname.exist?(@output_dir)

    @size = build_size(width)

    generate_image unless File.exist? target_filename
  end

  def name
    name = File.basename(@source_file, '.*')
    name << '_' + "#{@output_size[:width]}by#{@output_size[:height]}"
    name << source_digest
    name << '.' + @format
  end

  def absolute_filename
    File.join(@output_dir, name)
  end

  def aspect_ratio
    source_size[:width] / source_size[:height]
  end

  def source_size
    width, height = FastImage.size(@source_image)

    {
      width: width,
      height: height
    }
  end

  private

  def build_size(width)
    if width <= source_size[:width]
      {
        width: width,
        height: (width / aspect_ratio).round
      }
    else
      warn 'Warning:'.yellow + " #{@source_file} is smaller than requested" \
        ' output. Will use original size instead.'

      source_size
    end
  end

  def source_digest
    Digest::MD5.hexdigest(File.read(@source_file))[0..5]
  end

  def generate_image
    image = MiniMagick::Image.open(@source_file)
    # Scale and crop
    image.combine_options do |i|
      i.resize "#{@output_size[:width]}x#{@output_size[:height]}^"
      i.format @format
      i.strip
    end

    image.write absolute_filename
  end
end
