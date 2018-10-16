module PictureTag
  require 'objective_elements'
  require_relative 'source'
  # This represents all of the HTML markup that will be returned. Given the high
  # level plan, it builds all its own sources (each of which generate their own
  # images). It in herits from a generic HTML Double Tag, because that's what it
  # is.
  class Picture < DoubleTag
    attr_reader :instructions, :preset, :preset_name, :attributes
    def initialize(
      instructions:,
      preset:,
      preset_name:,
      attributes: nil
    )

      @instructions = instructions
      @preset = preset
      @preset_name = preset_name
      @attributes = attributes

      super(
        element: 'picture',
        attributes: attributes['picture'],
        content: content
      )
    end

    def content
      build_sources << build_fallback
    end

    def build_sources
      preset['sources'].collect { |s| build_source(s) }
    end

    def build_source(source_name)
      Source.new(
        source_filename: instructions[:source_images][source_name],
        destination_dir: instructions[:destination_dir],
        preset: preset,
        source_name: source_name
      )
    end

    def build_fallback
      SingleTag.new(
        element: 'img',
        attributes: attributes['img']
      )
    end
  end
end
