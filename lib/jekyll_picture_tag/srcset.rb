# Represents a srcset attribute, which can be applied to either a source tag or
# an img tag. Generates its own files.
class SrcSet
  attr_reader :media

  def initialize(media:, format:, instructions:)
    @media = media # Associated Media Query
    @format = @instructions.process_format(format) # Output format
    @instructions = instructions

    # Image filename, relative to jekyll_picture_tag default dir:
    @image = @instructions.source_images[@media]
    # Array of sizes to construct images for.
    @widths = @instructions.widths[@media]
  end

  def to_a
    @widths.collect { |w| build_srcset_entry(w) }
  end

  def to_s
    to_a.join(', ')
  end

  def mime_type
    mime_types[@format]
  end

  private

  def build_srcset_entry(width)
    file = generate_file(width)
    srcset_entry_text file
  end

  # Building block for a basic srcset entry. Don't include commas.
  def srcset_entry_text(file)
    "#{@instructions.build_url(file.name)} #{file.width}w"
  end

  def generate_file(width)
    GeneratedImage.new(
      source_dir: @instructions.source_dir,
      source_image: @image,
      output_dir: @instructions.dest_dir,
      width: width,
      format: @format
    )
  end

  # Yeah, I know hardcoding these isn't ideal, but I'm not pulling in a new
  # dependency for 9 lines of easy code.
  def mime_types
    {
      'gif'  => 'image/gif',
      'jpg'  => 'image/jpeg',
      'jpeg' => 'image/jpeg',
      'png'  => 'image/png',
      'webp' => 'image/webp'
    }
  end
end
