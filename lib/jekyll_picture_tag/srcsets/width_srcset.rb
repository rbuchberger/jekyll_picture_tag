# Creates a srcset in the "(filename) (width)w, (...)" format.
class WidthSrcset
  include BasicSrcset

  def to_a
    widths.collect { |w| build_srcset_entry(w) }
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
