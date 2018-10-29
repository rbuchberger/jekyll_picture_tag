# Containst all possible HTML output format options. Auto is considered its own
# option.
module OutputFormats
  requre_relative 'auto'
  requre_relative 'img'
  requre_relative 'picture'
  # Generic functions common to all output formats.
  module Basics
    def initialize(instructions)
      @instructions = instructions
    end

    private

    def build_srcset(media, format)
      if @instructions.preset['pixel_ratios']
        build_pixel_ratio_srcset(media, format)
      else
        build_width_srcset(media, format)
      end
    end

    def build_pixel_ratio_srcset(media, format)
      Srcsets::PixelRatio.new(media: media, format: format,
                              instructions: @instructions)
    end

    def build_width_srcset(media, format)
      Srcsets::Width.new(media: media, format: format,
                         instructions: @instructions)
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

    # Used for both the fallback image, and for the complete markup.
    def build_base_img
      img = SingleTag.new 'img'
      img.attributes << @instructions.attributes['img']

      img.src = @instructions.build_url(build_fallback_image.name)
      img.alt = @instructions.attributes['alt']

      img
    end

    # File, not HTML
    def build_fallback_image
      GeneratedImage.new(
        source_dir: @instructions.source_dir,
        source_image: @instructions.source_images[:nil],
        format: @instructions.fallback_format,
        width: @instructions.fallback_width,
        output_dir: @instructions.dest_dir
      )
    end
  end
end
