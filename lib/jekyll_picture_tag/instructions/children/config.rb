module PictureTag
  module Instructions
    # PictureTag configuration in _config.yml
    class Pconfig < Instruction
      def source
        PictureTag.config['picture']
      end
    end

    # https://example.com/my-base-path/assets/generated-images/image.jpg
    #                     ^^^^^^^^^^^^^
    # |     domain       |  baseurl   |       directory       | filename
    class Baseurl < Instruction
      def source
        {
          ignore: PictureTag.pconfig['ignore_baseurl'],
          key: PictureTag.pconfig['baseurl_key']
        }
      end

      def coerce
        return '' if source[:ignore]

        PictureTag.config[source[:key]] || ''
      end
    end

    # Whether to use relative or absolute URLs for images.
    class RelativeUrl < EnvInstruction
      def source
        PictureTag.pconfig['relative_url']
      end
    end

    # Image source directory
    class SourceDir < Instruction
      private

      def source
        [
          PictureTag.site.source,
          PictureTag.pconfig['source']
        ]
      end

      def coerce
        File.join(*source.map(&:to_s))
      end

      def setting_name
        'source directory'
      end
    end

    # Image output directory
    class DestDir < Instruction
      private

      def source
        [
          PictureTag.site.config['destination'],
          PictureTag.pconfig['output']
        ]
      end

      def coerce
        File.join(*source.map(&:to_s))
      end
    end

    # Whether to continue if a source image is missing
    class ContinueOnMissing < EnvInstruction
      def source
        PictureTag.pconfig['ignore_missing_images']
      end
    end

    # Whether to use a CDN
    class Cdn < EnvInstruction
      def source
        {
          url: PictureTag.pconfig['cdn_url'],
          setting: PictureTag.pconfig['cdn_environments']
        }
      end

      def coerce
        source[:url] && super
      end
    end

    # CDN URL
    class CdnUrl < Instruction
      def source
        PictureTag.pconfig['cdn_url']
      end

      def valid?
        require 'uri'
        uri = URI(source)

        # If the URI library can't parse it, it's not valid.
        uri.scheme && uri.host
      end

      def error_message
        <<~HEREDOC
          cdn_url must be a valid URI in the following format: https://example.com/
          current setting: #{source}
        HEREDOC
      end
    end

    # Disable JPT?
    class Disabled < EnvInstruction
      def source
        PictureTag.pconfig['disabled']
      end
    end

    # Fast build?
    class FastBuild < EnvInstruction
      def source
        PictureTag.pconfig['fast_build']
      end
    end
  end
end
