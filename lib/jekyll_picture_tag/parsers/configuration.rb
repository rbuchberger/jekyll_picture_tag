module PictureTag
  module Parsers
    # Global config (big picture). loads jekyll data/config files, and the j-p-t
    # defaults from included yml files.
    class Configuration
      # returns jekyll's configuration (picture is a subset)
      def [](key)
        content[key]
      end

      private

      def content
        @content ||= setting_merge(DEFAULT_CONFIG, PictureTag.site.config)
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
    end
  end
end
