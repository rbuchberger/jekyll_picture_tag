module PictureTag
  class SrcSet
    def initialize(source_name, attributes, ppi_list)
      @source_name = source_name
      @attributes = attributes
      @ppi_list = ppi_list
    end

    def build_ppi_srcset(source_name, attributes)
      # Returns a srcset
      srcset_list = ppi_list.collect do |ppi|
        entry = filename(@instructions[:source_images][source_name],
                         source_name,
                         ppi,
                         attributes[:format])
        entry << " #{ppi}x"
      end
      srcset_list.join ', '
    end
  end
end
