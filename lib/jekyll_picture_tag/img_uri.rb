require 'addressable'

module PictureTag
  # Represents a link to an image. We use the File library rather than the URI
  # library to build these because it doesn't like relative URIs.
  #
  # Just give it a filename, and pass source_image: true if it's not a generated
  # image. Call to_s on it to get the link.
  class ImgURI
    attr_reader :filename, :source_image
    def initialize(filename, source_image: false)
      @source_image = source_image
      @filename = filename
    end

    # https://example.com/my-base-path/assets/generated-images/image.jpg
    # |     domain       |  baseurl   |       directory       | filename
    def to_s
      Addressable::URI.escape(
        File.join(domain, baseurl, directory, @filename)
      )
    end

    private

    # https://example.com/my-base-path/assets/generated-images/image.jpg
    # ^^^^^^^^^^^^^^^^^^^^
    # |     domain       |  baseurl   |    j-p-t output dir   | filename
    def domain
      if PictureTag.cdn?
        PictureTag.pconfig['cdn_url']
      elsif PictureTag.pconfig['relative_url']
        ''
      else
        PictureTag.config['url'] || ''
      end
    end

    # https://example.com/my-base-path/assets/generated-images/image.jpg
    #                     ^^^^^^^^^^^^^
    # |     domain       |  baseurl   |       directory       | filename
    def baseurl
      PictureTag.config['baseurl'] || ''
    end

    # https://example.com/my-base-path/assets/generated-images/image.jpg
    #                                  ^^^^^^^^^^^^^^^^^^^^^^^^
    # |     domain       |  baseurl   |       directory       | filename
    def directory
      PictureTag.pconfig[
        @source_image ? 'source' : 'output'
      ]
    end
  end
end
