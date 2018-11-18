# Generated Image
# Represents a generated source file.
class GeneratedImage
  require 'fileutils'
  require 'pathname'
  require 'digest/md5'
  require 'mini_magick'
  require 'fastimage'

  def initialize(source_file:, width:, format:)
    @source_file = grab_source_file(source_file)
    @format = format

    # Base name will be prepended to generated filename.
    # Includes path relative to default sorce folder, and the original filename.
    @base_name = source_file.delete_suffix File.extname source_file

    @size = build_size(width)

    generate_image unless File.exist? absolute_filename
  end

  def name
    name = File.basename(@source_file, '.*')
    name << "-#{@size[:width]}by#{@size[:height]}-"
    name << source_digest
    name << '.' + @format
  end

  def absolute_filename
    File.join(PictureTag.config.dest_dir, name)
  end

  def aspect_ratio
    source_size[:width].to_f / source_size[:height].to_f
  end

  def source_size
    width, height = FastImage.size(@source_file)

    {
      width: width,
      height: height
    }
  end

  def width
    @size[:width]
  end

  private

  def grab_source_file(source_file)
    source_name = File.join(PictureTag.config.source_dir, source_file)

    unless File.exist? source_name
      raise "Jekyll Picture Tag could not find #{source_name}."
    end

    source_name
  end

  def build_size(width)
    if width <= source_size[:width]
      { width: width, height: (width / aspect_ratio).round }
    else
      warn 'Jekyll Picture Tag Warning:'.yellow +
           " #{@source_file} is #{source_size[:width]}px wide, "\
           "smaller than requested output (#{width}px)."\
           ' Will use original size instead.'

      source_size
    end
  end

  def source_digest
    Digest::MD5.hexdigest(File.read(@source_file))[0..5]
  end

  def generate_image
    puts 'Generating new image file: ' + name
    image = MiniMagick::Image.open(@source_file)
    # Scale and crop
    image.combine_options do |i|
      i.resize "#{@size[:width]}x#{@size[:height]}^"
      i.strip
    end

    image.format @format

    image.write absolute_filename
  end
end
