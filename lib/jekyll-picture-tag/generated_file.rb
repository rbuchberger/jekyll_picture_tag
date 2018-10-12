module PictureTag
  class GeneratedImage
    # Represents a generated source file, to point a srcset at.
    # Properties:
    # source filename, destination filename, size (width or height, accounting
    # for PPI), image format, PPI, source name
    # value
    def initialize(source_filename, source_name, preset)
      @source_filename = source_filename
      @source_name = source_name
      @preset = preset_attributes # picture.yml[preset_name][source_name]
    end

    def filename(source_filename, source_name, ppi, format)
      name = "#{source_filename}_#{source_name}"
      name << "_#{ppi}x" unless ppi == 1
      name << ".#{format}"
    end
  end
end
