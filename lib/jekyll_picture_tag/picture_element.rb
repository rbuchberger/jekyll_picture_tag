# This represents all of the HTML markup that will be returned. Given the high
# level plan, it builds all its own sources (each of which generate their own
# images).
class PictureElement
  def initialize(instructions)
    @instructions = instructions
  end

  def to_s
    srcsets = build_srcsets

    # We only need an actual picture tag when there is more than one srcset,
    # which means we're using either multiple source image and art direction, or
    # multiple formats.
    if srcsets.length > 1
      build_picture.to_s
    else
      build_img(srcsets.first).to_s
    end
  end

  private

  def build_srcsets
    sets = []

    # Source images are defined by their media queries:
    @instructions.source_images.each_key do |media|
      @instructions.preset.formats.each do |format|
        sets << SrcSet.new(media: media, image: image, format: format,
                           widths: widths, dest_dir: @instructions.dest_dir)
      end
    end

    # Media queries are given from most to least restrictive, but the markup
    # requires them the other way around:
    sets.reverse
  end

  def build_sizes
    sizes = []
    @instructions.preset[:sizes].each_pair do |media, size|
      sizes << "(#{media_preset[media]}) #{size}"
    end

    sizes << @instructions.preset[:size]
    sizes.join ', '
  end

  def build_url(filename)
    Pathname.join(@instructions.url_prefix, filename)
  end

  # Checks to ensure file exists.
  def source_image(media_query)
    # Filename relative to source directory:
    image = @instructions.source_images[media_query]
    # Complete filename:
    filename = File.join(@instructions.source_dir, image)
    # Only return image if it exists:
    return image if File.exist?(filename)

    raise "Could not find #{filename}"
  end

  def generate_file(image, format, width)
    GeneratedImage.new(
      source_image: image,
      output_dir: @instructions.dest_dir,
      width: width,
      format: format
    )
  end

  def build_picture
    DoubleTag.new(
      element: 'picture',
      attributes: instructions.attributes[:picture],
      content: build_sources << build_base_img
    )
  end

  def build_sources
    srcsets.collect { |s| build_source(s) }
  end

  def build_source(srcset)
    source = SingleTag.new('source',
                           attributes: @instructions.attributes[:source])

    # Sizes will be the same for all sources. There's some redundant markup
    # here, but I don't think it's worth the effort to prevent.
    source.sizes = build_sizes

    # The srcset has an associated media query, which might be nil. Don't apply
    # it if that's the case:
    source.media = srcset.media if srcset.media

    source.srcset = srcset.to_s
    source.type = srcset.mime_type
    source
  end

  # Used for both the fallback image, and for the complete markup.
  def build_base_img
    img = SingleTag.new 'img'
    img.attributes << @instructions.attributes[:img]
    img.alt = @instructions.attributes[:alt]
    img.src = build_url(build_fallback_image.name)
    img
  end

  # File, not HTML
  def build_fallback_image
    GeneratedImage.new(
      source_image: @instructions.source_images[:nil],
      format: @instructions.fallback_format,
      width: @instructions.fallback_width,
      output_dir: @instructions.dest_dir
    )
  end

  # Used when <picture> is unnecessary.
  def build_img(srcset)
    img = build_base_img
    img.srcset = srcset
    img.sizes = build_sizes
    img.to_s
  end
end
