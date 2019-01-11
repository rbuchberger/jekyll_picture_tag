module PictureTag
  # This is a little module to hold logic that doesn't fit other places. If it
  # starts getting big, refactor.
  module Utils
    # Configure Jekyll to keep our generated files
    def self.keep_files
      dest_dir = PictureTag.config['picture']['output']

      # Chop a slash off the end, if it's there. Doesn't work otherwise.
      dest_dir = dest_dir[0..-2] if dest_dir =~ %r{/\z}

      return if PictureTag.site.config['keep_files'].include?(dest_dir)

      PictureTag.site.config['keep_files'] << dest_dir
    end

    # Print a warning to the console
    def self.warning(message)
      return if PictureTag.config['picture']['suppress_warnings']

      warn 'Jekyll Picture Tag Warning: '.yellow + message
    end

    # Parse a liquid template; allows liquid variables to be included as tag
    # params.
    def self.liquid_lookup(params)
      Liquid::Template.parse(params).render(PictureTag.context)

      # This gsub allows people to include template code for javascript
      # libraries such as handlebar.js. It adds complication and I'm not sure
      # it has much value now, so I'm commenting it out. If someone has a use
      # case for it we can add it back in.
      # .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
    end

    # Allows us to use 'original' as a format name.
    def self.process_format(format, media)
      if format.casecmp('original').zero?
        PictureTag.source_images[media].ext
      else
        format.downcase
      end
    end

    # Used for auto markup configuration and such
    def self.count_srcsets
      formats = PictureTag.preset['formats'].length
      source_images = PictureTag.source_images.length

      formats * source_images
    end

    def self.check_ruby_version
      required_ruby = Gem::Version.new(REQUIRED_RUBY_VERSION)
      current_ruby = Gem::Version.new(RUBY_VERSION)

      return unless current_ruby < required_ruby

      raise <<~HEREDOC
        Jekyll Picture Tag is incompatible with your installed version of Ruby,
        which is #{RUBY_VERSION}. Please update to #{REQUIRED_RUBY_VERSION} or
        later.
      HEREDOC
    end
  end
end
