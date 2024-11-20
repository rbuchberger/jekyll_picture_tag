module PictureTag
  module OutputFormats
    # Returns only a srcset attribute, for more custom or complicated markup.
    class Css < Basic
      def to_s
        @image = PictureTag.source_images.first
        @format = PictureTag.formats.first

        css
      end

      def css

        css = ""
        for i in self.srcset.split(",") do
          a,b = i.split(" ")
          css += "@media only screen and (max-width: " + b[0...-1] + "px) {\n"
          css += "  ." + self.css_class_name + " {\n"
          css += "    background-image: url('" + a + "');\n"
          css += "  }\n}\n"
        end
        css
      end

      def srcset
        srcset = build_srcset(@image, @format).to_s
      end
      
      def css_class_name
          PictureTag.params.css_class
      end
      
    end
  end
end
