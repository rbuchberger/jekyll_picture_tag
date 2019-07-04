module PictureTag
  # This is a little module to hold logic that doesn't fit other places. If it
  # starts getting big, refactor.
  module Utils
    class << self
      # Configure Jekyll to keep our generated files
      def keep_files
        dest_dir = PictureTag.config['picture']['output']

        # Chop a slash off the end, if it's there. Doesn't work otherwise.
        dest_dir = dest_dir[0..-2] if dest_dir =~ %r{/\z}

        return if PictureTag.site.config['keep_files'].include?(dest_dir)

        PictureTag.site.config['keep_files'] << dest_dir
      end

      # Print a warning to the console
      def warning(message)
        return if PictureTag.config['picture']['suppress_warnings']

        warn 'Jekyll Picture Tag Warning: '.yellow + message
      end

      # Parse a liquid template; allows liquid variables to be included as tag
      # params.
      def liquid_lookup(params)
        Liquid::Template.parse(params).render(PictureTag.context)
      end

      # Used for auto markup configuration and such
      def count_srcsets
        formats = PictureTag.formats.length
        source_images = PictureTag.source_images.length

        formats * source_images
      end

      # Returns whether or not the current page is a markdown file.
      def markdown_page?
        page_name = PictureTag.page['name']
        page_ext = PictureTag.page['ext']
        ext = page_ext || File.extname(page_name)

        ext.casecmp('.md').zero? || ext.casecmp('.markdown').zero?
      end

      # Returns the widest source image
      def biggest_source
        PictureTag.source_images.values.max_by(&:width)
      end

      def titleize(input)
        input.split('_').map(&:capitalize).join
      end
    end
  end
end