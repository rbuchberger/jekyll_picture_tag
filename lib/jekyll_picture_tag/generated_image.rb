require 'mini_magick'
require 'base32'

module PictureTag
  # Represents a generated image file.
  class GeneratedImage
    attr_reader :width, :format
    include MiniMagick

    def initialize(source_file:, width:, format:, crop: nil, gravity: '')
      @source = source_file
      @width  = width
      @format = process_format format
      @crop = crop
      @gravity = gravity
    end

    def exists?
      File.exist?(absolute_filename)
    end

    def generate
      generate_image unless @source.missing || exists?
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def absolute_filename
      @absolute_filename ||= File.join(PictureTag.dest_dir, name)
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    #                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def name
      name_left + digest + name_right
    end

    # https://example.com/assets/images/myimage-100-123abc.jpg
    #                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    def uri
      ImgURI.new(name).to_s
    end

    def cropped_source_width
      image.width
    end

    private

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    #                                    ^^^^^^^^^^^^^^^^^^^^^^^
    def name_left
      "#{@source.base_name}-#{@width}-"
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    #                                                           ^^^^^^
    def digest
      guess_digest if !@source.digest_guess && PictureTag.fast_build?

      @source.digest
    end

    # /home/dave/my_blog/_site/generated/somefolder/myimage-100-123abc.jpg
    #                                                                 ^^^^
    def name_right
      crop_code + '.' + @format
    end

    # Hash the crop settings, so we can detect when they change.  We use a
    # base32 encoding scheme to pack more information into fewer characters,
    # without dealing with various filesystem naming limitations that would crop
    # up using base64 (such as NTFS being case insensitive).
    def crop_code
      return '' unless @crop

      Base32.encode(
        Digest::MD5.hexdigest(@crop + @gravity)
      )[0..2]
    end



    def dest_glob

    end

    def generate_image
      puts 'Generating new image file: ' + name
      process_image
      write_image
    end

    def image
      @image ||= open_image
    end

    def open_image
      image_base = Image.open(@source.name)
      image_base.combine_options do |i|
        i.auto_orient
        if @crop
          i.gravity @gravity
          i.crop @crop
        end
      end

      image_base
    end

    def process_image
      image.combine_options do |i|
        i.resize "#{@width}x"
        i.strip
      end

      image.format @format
      image.quality PictureTag.quality(@format)
    end

    def write_image
      FileUtils.mkdir_p(File.dirname(absolute_filename))

      image.write absolute_filename

      FileUtils.chmod(0o644, absolute_filename)
    end

    def process_format(format)
      if format.casecmp('original').zero?
        @source.ext
      else
        format.downcase
      end
    end
  end
end
