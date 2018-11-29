module PictureTag
  module Instructions
    # Global config (big picture). loads jekyll data/config files, and the j-p-t
    # defaults from included yml files.
    class Configuration
      def initialize
        @content = build_config
      end

      def [](key)
        @content[key]
      end

      # Site.source is the master jekyll source directory
      # Source dir is the jekyll-picture-tag source directory.
      def source_dir
        File.join PictureTag.site.source, self['picture']['source']
      end

      # site.dest is the master jekyll destination directory
      # source_dest is the jekyll-picture-tag destination directory. (generated
      # file location setting.)
      def dest_dir
        File.join PictureTag.site.dest, self['picture']['output']
      end

      # Takes our config into account.
      def build_url(filename)
        File.join url_prefix, filename
      end

      private

      def build_config
        YAML.safe_load(
          # Jekyll Picture Tag Default settings
          File.read(
            File.join(ROOT_PATH, 'jekyll-picture-tag/defaults/global.yml')
          )
        ).merge(
          # _config.yml defined settings
          PictureTag.site.config
        ) do |_key, jpt_default, site_value|
          setting_merge(jpt_default, site_value)
        end
      end

      def setting_merge(jpt_default, site_value)
        if site_value.nil?
          # Jekyll baseurl is nil if not configured, which breaks things.
          # jpt_default is an empty string, which doesn't.
          jpt_default
        elsif site_value.is_a? Hash
          # We'll merge hashes one level deep. If we need true deep merging,
          # we'll import a gem or do something recursive.
          jpt_default.merge site_value
        else
          site_value
        end
      end

      # https://example.com/my-base-path/assets/generated-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # |     site url     | site path  |    j-p-t dest dir     |
      def url_prefix
        File.join(
          PictureTag.config['url'],
          PictureTag.config['baseurl'],
          self['picture']['output']
        )
      end
    end
  end
end
