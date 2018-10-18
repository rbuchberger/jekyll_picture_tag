# Generated Image
# Represents a generated source file, to point a srcset at.
# Properties:
# source filename, destination filename, size (width or height, accounting
# for PPI), image format, PPI, source name
# value
class GeneratedImage
  require 'fileutils'
  require 'pathname'
  require 'digest/md5'
  require 'mini_magick'
  require 'fastimage'

  attr_reader :pixel_ratio

  def initialize(source_dir:, source_file:, output_dir:, size:, format:)
    @source_dir = source_dir
    @output_dir = output_dir
    @source_file = File.join(source_dir, source_file)
    @format = format || File.extname(@source_file)

    # Base name will be prepended to generated filename.
    # Includes path relative to default sorce folder, and the original filename.
    @base_name = source_file.delete_suffix File.extname source_file

    #  If the destination directory doesn't exist, create it
    FileUtils.mkdir_p(@output_dir) unless Pathname.exist?(@output_dir)

    @output_size = build_size(size)
    generate_image unless File.exist? target_filename
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

  def target_size(partial_size)
    @pixel_ratio = partial_size[:pixel_ratio]

    width = partial_size[:width] || partial_size[:height] * aspect_ratio
    height = partial_size[:height] || partial_size[:width] / aspect_ratio

    {
      width: width * @pixel_ratio,
      height: height * @pixel_ratio
    }
  end

  def build_size(partial_size)
    target_size(partial_size).merge(source_size) do |key, target, source|
      # Ensures we don't attempt to enlarge any images:
      if target < source
        target.round
      else
        warn 'Warning:'.yellow +
             " #{@source_file} #{key} is smaller than the requested output." \
             " Will use original #{key} instead."
        source
      end
    end
  end

  def source_digest
    # Returns the first few characters of an md5 checksum
    Digest::MD5.hexdigest(
      File.read(@source_file)
    )[0..5]
  end

  def name
    name = File.basename(@source_file, '.*')
    name << '_' + "#{@output_size[:width]}by#{@output_size[:height]}"
    name << source_digest
    name << '.' + @format
  end

  def target_filename
    File.join(@output_dir, name)
  end

  def generate_image
    image = MiniMagick::Image.open(@source_file)
    # Scale and crop
    image.combine_options do |i|
      i.resize "#{@output_size[:width]}x#{@output_size[:height]}^"
      i.format @format
      i.gravity 'center'
      i.crop "#{@output_size[:width]}x#{@output_size[:height]}+0+0"
      i.strip
    end

    image.write target_filename
  end
end
