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
      require 'fastimage'
      attr_reader :media, :source_image

      def initialize(media:, format:)
        @media = media # Associated Media Query, can be nil

        # Output format:
        @format = Utils.process_format(format, media)

        @source_image = PictureTag.source_images[@media]
      end

      def to_s
        to_a.join(', ')
      end

      # Allows us to add a type attribute to whichever element contains this
      # srcset.
      def mime_type
        mime_types[@format]
      end

      # Some srcsets have them, for those that don't return nil.
      def sizes
        nil
      end

      # Check our source image size vs requested sizes
      def check_widths(targets)
        if targets.any? { |t| t > @source_image.width }
          handle_small_source(targets, @source_image.width)
        else
          targets
        end
      end

      # Generates an HTML attribute
      def media_attribute
        "(#{PictureTag.media_presets[@media]})"
      end

      private

      def handle_small_source(targets, image_width)
        warn 'Jekyll Picture Tag Warning:'.yellow +
             " #{@source_image} is #{image_width}px wide, smaller than at" \
             " least one requested size in the set #{targets}. Will not " \
             'enlarge.'

        small_targets = targets.delete_if { |t| t >= image_width }

        small_targets.push image_width

        small_targets
      end

      def generate_file(width)
        GeneratedImage.new(
          source_file: @source_image,
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
