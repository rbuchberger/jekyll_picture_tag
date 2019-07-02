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

      # Digs into jekyll context, returns current environment
      def jekyll_env
        # It would be really great if the jekyll devs actually documented
        # the context object.
        PictureTag.context.environments.first['jekyll']['environment']
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

      # Generated images, not source images.
      # https://example.com/my-base-path/assets/generated-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # |     domain       |  baseurl   |    j-p-t output dir   | filename
      def build_url(filename)
        File.join url_prefix, self['picture']['output'], filename
      end

      # For linking source images
      # https://example.com/my-base-path/assets/source-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # |     domain       |  baseurl   |   j-p-t source dir | filename
      def build_source_url(filename)
        File.join url_prefix, self['picture']['source'], filename
      end

      def nomarkdown?
        Utils.markdown_page? && self['picture']['nomarkdown']
      end

      def continue_on_missing?
        setting = @content['picture']['ignore_missing_images']

        # Config setting can be a string, an array, or a boolean
        if setting.is_a? Array
          setting.include? jekyll_env
        elsif setting.is_a? String
          setting == jekyll_env
        else
          setting
        end
      end

      private

      def build_config
        YAML.safe_load(
          # Jekyll Picture Tag Default settings
          File.read(
            File.join(ROOT_PATH, 'jekyll_picture_tag/defaults/global.yml')
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

      # Juuust complicated enough to extract to its own function.
      def cdn?
        self['picture']['cdn_url'] &&
          self['picture']['cdn_environments'].include?(jekyll_env)
      end

      # https://example.com/my-base-path/assets/generated-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^
      # |     domain       |  baseurl   |    j-p-t output dir   | filename
      def domain
        if cdn?
          self['picture']['cdn_url']
        elsif self['picture']['relative_url']
          ''
        else
          self['url']
        end
      end

      # https://example.com/my-base-path/assets/generated-images/image.jpg
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      # |     domain       |  baseurl   |    j-p-t output dir   | filename
      def url_prefix
        # We use file.join because the ruby url methods don't like relative
        # urls.
        File.join(
          domain,
          self['baseurl']
        )
      end
    end
  end
end
