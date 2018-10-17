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

  def initialize(
    source_image:,
    output_dir:,
    size:,
    format:
  )
    @source_file = source_image
    @format = format || File.extname(@source_file)
    @output_dir = output_dir

    #  If the destination directory doesn't exist, create it
    FileUtils.mkdir_p(@output_dir) unless File.exist?(@output_dir)

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
    width = partial_size[:width] || partial_size[:height] * aspect_ratio
    height = partial_size[:height] || partial_size[:width] / aspect_ratio

    {
      width: width * partial_size[:pixel_ratio],
      height: height * partial_size[:pixel_ratio]
    }
  end

  def build_size(partial_size)
    target_size(partial_size).merge(source_size) do |key, target, source|
      # Ensures we don't attempt to enlarge any images:
      if target < source
        target
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
    name << '_' + source_name
    name << "_#{@output_size[:pixel_ratio]}x"
    name << source_digest
    name << '.' + @format
    name
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
