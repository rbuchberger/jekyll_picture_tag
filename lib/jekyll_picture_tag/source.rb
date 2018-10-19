# Generates a string value to serve as the srcset attribute for a given
# <source> or <img> tag.
class Source < SingleTag
  attr_reader :name

  def initialize(instructions, source_name)
    @instructions = instructions
    @name = source_name
    @files = build_files

    super 'source', attributes: @instructions.attributes[:source]
  end

  def build_files
    files = {}
    # Pixel ratios are keys, values are the generated files.
    pixel_ratios.each do |p|
      files[p] = GeneratedImage.new(
        source_image: source_image,
        output_dir: @instructions.dest_dir,
        size: size(p),
        format: source_preset['format']
      )
    end
  end

  def source_preset
    @instructions.preset['sources'][name]
  end

  def size(pixel_ratio = 1)
    unless source_preset['width'] || source_preset['height']
      raise "Preset #{@instructions.preset_name}:"\
        " source #{name} must include either a width or a height."
    end

    {
      width: source_preset['width'] * pixel_ratio,
      height: source_preset['height'] * pixel_ratio
    }
  end

  def source_image
    # Filename relative to source directory:
    image = @instructions.source_images[name]
    # Complete filename:
    filename = File.join(@instructions.source_dir, image)
    # Only return image if it exists:
    return image if File.exist?(filename)

    raise "Could not find #{filename}"
  end

  def pixel_ratios
    if @instructions.preset['pixel_ratios']
      @instructions.preset['pixel_ratios'].map(&:to_i)
    else
      [1]
    end
  end

  def srcset
    set = files.each_pair do |pixel_ratio, file|
      url = Pathname.join(@instructions.url_prefix, file.name)

      "#{url} #{pixel_ratio}x"
    end

    set.join ', '
  end

  def to_s
    rewrite_attributes srcset: srcset, media: source_preset['media']
    super
  end
end
