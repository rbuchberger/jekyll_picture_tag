require 'mini_magick'

module PictureTag
  # Represents a generated image file.
  class GeneratedImage
    attr_reader :width, :format
    include MiniMagick

    def initialize(source_file:, width:, format:)
      @source = source_file
      @width  = width
      @format = process_format format
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
      '.' + @format
    end

    # Used for the fast build option: look for a file which matches everything
    # we know about the destination file without calculating a digest on the
    # source file, and if it exists we assume it's the right one.
    def guess_digest
      matches = dest_glob
      return unless matches.length == 1

      # Start and finish of the destination image's hash value
      finish = -name_right.length
      start = finish - 6

      # The source image keeps track of this guess, so we hand it off:
      @source.digest_guess = matches.first[start...finish]
    end

    # Returns a list of images which are probably correct.
    def dest_glob
      Dir.glob File.join(PictureTag.dest_dir, name_left + '?' * 6 + name_right)
    end

    def image
      @image ||= Image.open(@source.name)
    end

    def dest_dir
      File.dirname absolute_filename
    end

    def generate_image
      puts 'Generating new image file: ' + name
      process_image
      write_image
    end

    def process_image
      image.combine_options do |i|
        i.resize "#{@width}x"
        i.auto_orient
        i.strip
      end

      image.format @format
      image.quality PictureTag.quality(@format)
    end

    def write_image
      check_dest_dir

      image.write absolute_filename

      FileUtils.chmod(0o644, absolute_filename)
    end

    # Make sure destination directory exists
    def check_dest_dir
      FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)
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
