module PictureTag
  # Handles srcset generation, which also handles file generation.
  module Srcsets
    # Basic functionality for a srcset, which also handles file generation.
    # Classes including this module must implement the to_a method, which
    # accomplishes the following:
    # - Return an array of srcset entries.
    # - Call generate_file for each entry, giving it the desired width in
    #   pixels.
    module Basics
      attr_reader :media

      def initialize(media:, format:, instructions:)
        @media = media # Associated Media Query, can be nil
        @format = @instructions.process_format(format) # Output format
        @instructions = instructions

        # Image filename, relative to jekyll_picture_tag default dir:
        @image = @instructions.source_images[@media]
      end

      def to_s
        to_a.join(', ')
      end

      # Allows us to add a type attribute to whichever element contains this
      # srcset.
      def mime_type
        mime_types[@format]
      end

      private

      def generate_file(width)
        GeneratedImage.new(
          source_dir: @instructions.source_dir,
          source_image: @image,
          output_dir: @instructions.dest_dir,
          width: width,
          format: @format
        )
      end

      # Hardcoding these isn't ideal, but I'm not pulling in a new dependency
      # for 9 lines of easy code.
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
  end
end
