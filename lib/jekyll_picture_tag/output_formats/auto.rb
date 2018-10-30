module OutputFormats
  # Automatically select which output format to return.
  class Auto
    def initialize(instructions)
      formats = instructions.preset['formats'].length
      sources = instructions.source_images.length

      @element = if formats > 1 || sources > 1
                   Picture.new(instructions)
                 else
                   Img.new(instructions)
                 end
    end

    def to_s
      @element.to_s
    end
  end
end
