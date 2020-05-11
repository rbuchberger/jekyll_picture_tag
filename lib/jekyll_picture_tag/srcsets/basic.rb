require 'mime-types'
module PictureTag
  # Handles srcset generation, which also handles file generation.
  module Srcsets
    # Basic functionality for a srcset, which also handles file generation.
    # Classes including this module must implement the to_a method, which
    # accomplishes the following:
    # - Return an array of srcset entries.
    # - Call generate_file for each entry, giving it the desired width in
    #   pixels.
    class Basic
      attr_reader :source_image, :media

      def initialize(source_image, input_format)
        @source_image = source_image
        @input_format = input_format
        @media = source_image.media_preset
      end

      def format
        # Input format might be 'original', which is handled by the generated
        # image.
        @format ||= files.first.format
      end

      def files
        @files ||= build_files
      end

      def to_a
        files.collect { |f| build_srcset_entry(f) }
      end

      def to_s
        to_a.join(', ')
      end

      # Allows us to add a type attribute to whichever element contains this
      # srcset.
      def mime_type
        MIME::Types.type_for(format).first.to_s
      end

      # Some srcsets have them, for those that don't return nil.
      def sizes
        nil
      end

      # Generates an HTML attribute
      def media_attribute
        "(#{PictureTag.media_presets[@media]})"
      end

      private

      def build_files
        # By 'files', we mean the GeneratedImage class.
        return target_files if target_files.all?(&:exists?)

        # This triggers GeneratedImage to actually build an image file.
        files = checked_targets
        files.each(&:generate)

        files
      end

      def checked_targets
        if target_files.any? { |f| f.width > source_width }

          small_source_warn

          files = target_files.reject { |f| f.width >= source_width }
          files.push(generate_file(source_width))
        end

        files || target_files
      end

      def source_width
        @source_width ||= if PictureTag.crop(@media)
                            target_files.first.cropped_source_width
                          else
                            @source_image.width
                          end
      end

      def target_files
        @target_files ||= widths.collect { |w| generate_file(w) }
      end

      def small_source_warn
        Utils.warning(
          <<~HEREDOC
            #{@source_image.shortname}
            is #{source_width}px wide (after cropping, if applicable),
            smaller than at least one size in the set #{widths}.
            Will not enlarge.
          HEREDOC
        )
      end

      def generate_file(width)
        GeneratedImage.new(
          source_file: @source_image,
          width: width,
          format: @input_format,
          crop: PictureTag.crop(@media),
          gravity: PictureTag.gravity(@media)
        )
      end
    end
  end
end
