module Srcsets
  # Creates a srcset in the "(filename) (width)w, (...)" format.
  class Width
    include Basics

    def to_a
      widths.collect { |w| build_srcset_entry(w) }
    end

    def sizes
      return nil unless @instructions.preset['sizes']

      sizes = []
      @instructions.preset[:sizes].each_pair do |media, size|
        sizes << "(#{media_preset[media]}) #{size}"
      end

      sizes << @instructions.preset[:size]

      sizes.join ', '
    end

    private

    def widths
      @instructions.widths[@media]
    end

    def build_srcset_entry(width)
      file = generate_file(width)

      "#{@instructions.build_url(file.name)} #{file.width}w"
    end
  end
end
