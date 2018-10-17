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
    source_file:,
    source_name:,
    size:,
    format:,
    destination:,
    pixel_ratio: 1
  )
    @source_file = source_file
    @format = format
    @source_name = source_name
    @destination = destination
    @pixel_ratio = pixel_ratio
    @size = build_size(size)
  end

  def build_size
    
  end

  def source_file_prefix
    @source_file.split('.').shift
  end

  def name
    name = ''
    name << @source_file
    name << '_' + source_name
    name << "_#{ppi}x" unless ppi == 1
    name << '.' + format
    name
  end

  def generate_image(instance, site_source, site_dest, image_source, image_dest, _baseurl)
    begin
      digest = Digest::MD5.hexdigest(File.read(File.join(site_source, image_source, instance[:src]))).slice!(0..5)
    rescue Errno::ENOENT
      warn 'Warning:'.yellow + " source image #{instance[:src]} is missing."
      return ''
    end

    image_dir = File.dirname(instance[:src])
    ext = File.extname(instance[:src])
    basename = File.basename(instance[:src], ext)

    size = FastImage.size(File.join(site_source, image_source, instance[:src]))
    orig_width = size[0]
    orig_height = size[1]
    orig_ratio = orig_width * 1.0 / orig_height

    gen_width = if instance[:width]
                  instance[:width].to_f
                elsif instance[:height]
                  orig_ratio * instance[:height].to_f
                else
                  orig_width
                end
    gen_height = if instance[:height]
                   instance[:height].to_f
                 elsif instance[:width]
                   instance[:width].to_f / orig_ratio
                 else
                   orig_height
                 end
    gen_ratio = gen_width / gen_height

    # Don't allow upscaling. If the image is smaller than the requested dimensions, recalculate.
    if orig_width < gen_width || orig_height < gen_height
      undersize = true
      gen_width = orig_ratio < gen_ratio ? orig_width : orig_height * gen_ratio
      gen_height = orig_ratio > gen_ratio ? orig_height : orig_width / gen_ratio
    end

    gen_name = "#{basename}-#{gen_width.round}by#{gen_height.round}-#{digest}#{ext}"
    gen_dest_dir = File.join(site_dest, image_dest, image_dir)
    gen_dest_file = File.join(gen_dest_dir, gen_name)

    # Generate resized files
    unless File.exist?(gen_dest_file)

      warn 'Warning:'.yellow + " #{instance[:src]} is smaller than the requested output file. It will be resized without upscaling." if undersize

      #  If the destination directory doesn't exist, create it
      FileUtils.mkdir_p(gen_dest_dir) unless File.exist?(gen_dest_dir)

      # Let people know their images are being generated
      puts "Generating #{gen_name}"

      image = MiniMagick::Image.open(File.join(site_source, image_source, instance[:src]))
      # Scale and crop
      image.combine_options do |i|
        i.resize "#{gen_width}x#{gen_height}^"
        i.gravity 'center'
        i.crop "#{gen_width}x#{gen_height}+0+0"
        i.strip
      end

      image.write gen_dest_file
      # Return path relative to the site root for html
      Pathname.new(File.join(baseurl, image_dest, image_dir, gen_name)).cleanpath
    end
  end
end
