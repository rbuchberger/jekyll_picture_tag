module PictureTag
  # Handles a given source image file and its properties. Provides a speed
  # advantage by storing expensive file reads and writes in instance variables,
  # to be reused by many different source images.
  class SourceImage
    attr_reader :name, :shortname

    def initialize(relative_filename)
      @shortname = relative_filename
      @name = grab_file relative_filename
    end

    def size
      @size ||= build_size
    end

    def width
      size[:width]
    end

    def aspect_ratio
      @aspect_ratio ||= size[:width].to_f / size[:height].to_f
    end

    def digest
      @digest ||= Digest::MD5.hexdigest(File.read(@name))[0..5]
    end

    # Includes path relative to default sorce folder, and the original filename.
    def base_name
      @shortname.delete_suffix File.extname(@shortname)
    end

    # File exention
    def ext
      # [1..-1] will strip the leading period.
      @ext ||= File.extname(@name)[1..-1].downcase
    end

    private

    def build_size
      width, height = FastImage.size(@name)

      {
        width: width,
        height: height
      }
    end

    # Turn a relative filename into an absolute one, and make sure it exists.
    def grab_file(source_file)
      source_name = File.join(PictureTag.config.source_dir, source_file)

      unless File.exist? source_name
        raise "Jekyll Picture Tag could not find #{source_name}."
      end

      source_name
    end
  end
end
