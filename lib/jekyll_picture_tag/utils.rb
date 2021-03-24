module PictureTag
  # This is a little module to hold logic that doesn't fit other places. If it
  # starts getting big, refactor.
  module Utils
    class << self
      # Configure Jekyll to keep our generated files
      def keep_files
        dest_dir = PictureTag.pconfig['output']

        # Chop a slash off the end, if it's there. Doesn't work otherwise.
        dest_dir = dest_dir[0..-2] if dest_dir =~ %r{/\z}

        return if PictureTag.site.config['keep_files'].include?(dest_dir)

        PictureTag.site.config['keep_files'] << dest_dir
      end

      # Print a warning to the console
      def warning(message)
        return if PictureTag.pconfig['suppress_warnings']

        warn 'Jekyll Picture Tag Warning: '.yellow + message
      end

      # Parse a liquid template; allows liquid variables to be included as tag
      # params.
      def liquid_lookup(params)
        Liquid::Template.parse(params).render(PictureTag.context)
      end

      # Used for auto markup configuration and such
      def count_srcsets
        PictureTag.formats.length * PictureTag.source_images.length
      end

      # Returns whether or not the current page is a markdown file.
      def markdown_page?
        page_name = PictureTag.page['name']
        page_ext = PictureTag.page['ext']
        ext = page_ext || File.extname(page_name)

        ext.casecmp('.md').zero? || ext.casecmp('.markdown').zero?
      end

      def titleize(input)
        input.split('_').map(&:capitalize).join
      end

      def snakeize(input)
        input.scan(/[A-Z][a-z]+/).map(&:downcase).join('_')
      end

      # Linear interpolator. Pass it 2 values in the x array, 2 values
      # in the y array, and an x value, returns a y value.
      def interpolate(xvals, yvals, xval)
        xvals.map!(&:to_f)
        yvals.map!(&:to_f)

        # Slope
        m = (yvals.last - yvals.first) / (xvals.last - xvals.first)
        # Value of y when x=0
        b = yvals.first - (m * xvals.first)
        # y = mx + b
        (m * xval) + b
      end

      def aspect_float(width, height)
        width.to_f / height
      end
    end
  end
end
