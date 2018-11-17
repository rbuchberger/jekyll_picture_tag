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
        File.join PictureTag.site.source, self['picture']['source_dir']
      end

      # site.dest is the master jekyll destination directory
      # source_dest is the jekyll-picture-tag destination directory. (generated
      # file location setting.)
      def dest_dir
        dir = File.join PictureTag.site.dest, self['picture']['destination_dir']
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

        dir
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
        )
      end

      # https://example.com/my-base-path/assets/generated-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # |     site url     | site path  |    j-p-t dest dir     |
      def url_prefix
        File.join(
          PictureTag.site.config['url'],
          PictureTag.site.config['baseurl'],
          self['picture']['destination_dir']
        )
      end
    end
  end
end
