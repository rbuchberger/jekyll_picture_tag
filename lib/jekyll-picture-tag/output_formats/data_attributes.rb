module PictureTag
  module OutputFormats
    # This is not an output format, it's a module for use in others. It allows
    # us to create JavaScript Library friendly markup, for things like LazyLoad
    module DataAttributes
      def base_markup
        build_noscript(super)
      end

      def build_base_img
        img = super

        add_temp_src img

        img
      end

      private

      def add_src(element, name)
        element.attributes << { 'data-src' => PictureTag.build_url(name) }
      end

      def add_srcset(element, srcset)
        element.attributes << { 'data-srcset' => srcset.to_s }
      end

      def add_sizes(element, srcset)
        element.attributes << { 'data-sizes' => srcset.sizes } if srcset.sizes
      end

      def build_noscript(base_content)
        return base_content unless PictureTag.preset['noscript']

        noscript = DoubleTag.new(
          'noscript',
          content: Img.new.build_base_img,

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        ).to_s

        ShelfTag.new(
          content: [base_content, noscript],

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        )
      end

      # Looks at temp_src setting in preset. Adds either a generated image or
      # the defined generic source image.
      def add_temp_src(img)
        return unless (preset_src = PictureTag.preset['temp_src'])

        img.src = if preset_src.is_a? Integer
                    generated_src preset_src
                  else
                    preset_src
                  end
      end

      # Takes our fallback image and adds a very low res src
      def generated_src(width)
        image = GeneratedImage.new(
          source_file: PictureTag.source_images[nil],
          format: PictureTag.fallback_format,
          width: width
        )

        PictureTag.build_url image.name
      end
    end
  end
end
