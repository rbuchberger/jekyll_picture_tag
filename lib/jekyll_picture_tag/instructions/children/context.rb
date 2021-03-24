module PictureTag
  module Instructions
    # Jekyll site info
    class Site < Instruction
      def source
        PictureTag.context.registers[:site]
      end
    end

    # Current page in jekyll site
    class Page < Instruction
      def source
        PictureTag.context.registers[:page]
      end
    end

    # Digs into jekyll context, returns current environment
    class JekyllEnv < Instruction
      def source
        PictureTag.context.environments.first['jekyll']['environment']
      end
    end
  end
end
