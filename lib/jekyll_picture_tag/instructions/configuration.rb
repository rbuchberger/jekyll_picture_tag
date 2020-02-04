module PictureTag
  module Instructions
    # Global config (big picture). loads jekyll data/config files, and the j-p-t
    # defaults from included yml files.
    class Configuration
      # returns jekyll's configuration (picture is a subset)
      def [](key)
        content[key]
      end

      # picturetag specific configuration
      def pconfig
        content['picture']
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
        File.join PictureTag.site.source, pconfig['source']
      end

      # site.dest is the master jekyll destination directory
      # source_dest is the jekyll-picture-tag destination directory. (generated
      # file location setting.)
      def dest_dir
        File.join PictureTag.site.dest, pconfig['output']
      end

      def nomarkdown?
        Utils.markdown_page? && pconfig['nomarkdown']
      end

      def continue_on_missing?
        env_check pconfig['ignore_missing_images']
      rescue ArgumentError
        raise ArgumentError,
              <<~HEREDOC
                continue_on_missing setting invalid. Must be either a boolean
                (true/false), an environment name, or an array of environment
                names.
              HEREDOC
      end

      def cdn?
        pconfig['cdn_url'] && pconfig['cdn_environments'].include?(jekyll_env)
      end

      def disabled?
        env_check pconfig['disabled']
      rescue ArgumentError
        raise ArgumentError,
              <<~HEREDOC
                "disabled" setting invalid. Must be either a boolean
                (true/false), an environment name, or an array of environment
                names.
              HEREDOC
      end

      def fast_build?
        env_check pconfig['fast_build']
      rescue ArgumentError
        raise ArgumentError,
              <<~HEREDOC
                "fast_build" setting invalid. Must be either a boolean
                (true/false), an environment name, or an array of environment
                names.
              HEREDOC
      end

      private

      def content
        @content ||= setting_merge(defaults, PictureTag.site.config)
      end

      # There are a few config settings which can either be booleans,
      # environment names, or arrays of environment names. This method works it
      # out and returns a boolean.
      def env_check(setting)
        if setting.is_a? Array
          setting.include? jekyll_env
        elsif setting.is_a? String
          setting == jekyll_env
        elsif [true, false].include? setting
          setting
        else
          raise ArgumentError,
                "#{setting} must either be a string, an array, or a boolean."
        end
      end

      def setting_merge(default, jekyll)
        jekyll.merge default do |_key, config_setting, default_setting|
          if default_setting.respond_to? :merge
            setting_merge(default_setting, config_setting)
          else
            config_setting
          end
        end
      end

      def defaults
        # Jekyll Picture Tag Default settings
        YAML.safe_load(
          File.read(
            File.join(
              ROOT_PATH, 'jekyll_picture_tag/defaults/global.yml'
            )
          )
        )
      end
    end
  end
end
