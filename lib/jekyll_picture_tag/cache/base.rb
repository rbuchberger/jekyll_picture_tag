require 'json'

module PictureTag
  module Cache
    # Basic image information cache functionality
    module Base
      def initialize(base_name)
        @base_name = base_name
      end

      def [](key)
        data[key]
      end

      def []=(key, value)
        raise ArgumentError unless template.keys.include? key

        data[key] = value
      end

      # Call after updating data.
      def write
        FileUtils.mkdir_p(File.join(base_directory, sub_directory))

        File.open(filename, 'w+') do |f|
          f.write JSON.generate(data)
        end
      end

      private

      def data
        @data ||= if File.exist?(filename)
                    JSON.parse(File.read(filename)).transform_keys(&:to_sym)
                  else
                    template
                  end
      end

      # /home/dave/my_blog/.jekyll-cache/jpt/(cache_dir)/assets/myimage.jpg.json
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      def base_directory
        File.join(PictureTag.site.cache_dir, 'jpt', cache_dir)
      end

      # /home/dave/my_blog/.jekyll-cache/jpt/(cache_dir)/assets/myimage.jpg.json
      #                                                 ^^^^^^^^
      def sub_directory
        File.dirname(@base_name)
      end

      # /home/dave/my_blog/.jekyll-cache/jpt/somefolder/myimage.jpg.json
      # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      def filename
        File.join(base_directory, @base_name + '.json')
      end
    end
  end
end
