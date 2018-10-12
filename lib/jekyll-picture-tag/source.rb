module PictureTag
  require 'objective_elements'
  # Generates a string value to serve as the srcset attribute for a given
  # <source> or <img> tag.
  class Source < SingleTag
    attr_reader :files, :preset, :source_filename, :source_name

    def initialize(source_filename, destination_dir, preset, source_name)
      @files = build_files
      @preset = preset
      @source_filename = source_filename
      @source_name = source_name # Which source within the preset. Needs better name
      @destination_dir = destination_dir

      super 'source'
    end

    def build_files
      files = []
      pixel_ratio_list.each do |p|
        files << GeneratedImage.new(
          source_filename,
          source_name,
          p,
          destination_dir,
          image_format
        )
      end
    end

    def source_preset
      preset['sources'][source_name]
    end

    def image_format
      source_preset['format']
    end

    def pixel_ratio_list
      if preset['pixel_ratios']
        preset['pixel_ratios'].map(&:to_i)
      else
        [1]
      end
    end

    def srcset
      files.collect { |f| "#{f.name} #{f.pixel_ratio}x" }.join ', '
    end

    def to_s
      rewrite_attributes srcset: srcset, media: source_preset['media']
      super
    end
  end
end
