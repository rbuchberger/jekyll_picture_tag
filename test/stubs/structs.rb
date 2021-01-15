module Stubs
  module Structs
    # Jekyll Picture Tag classes:

    ConfigStub =
      Struct.new(:source_dir)

    GeneratedImageStub =
      Struct.new(:name, :width, :uri, :format, :exists?, :generate, keyword_init:
                 true)

    # Rubocop doesn't want us to override to_s in a struct. Since it's for a test
    # stub, it's fine.
    # rubocop:disable Lint/StructNewOverride
    SrcsetStub =
      Struct.new(:sizes, :to_s, :media, :mime_type, :media_attribute)
    # rubocop:enable Lint/StructNewOverride

    SourceImageStub =
      Struct.new(:base_name, :name, :missing, :digest, :ext, :width, :shortname,
                 :media_preset, :digest_guess, keyword_init: true)

    # Jekyll classes:

    SiteStub =
      Struct.new(:config, :data, :source, :dest, :cache_dir)

    ContextStub =
      Struct.new(:environments, :registers)

    TokenStub =
      Struct.new(:line_number, :locale)

    # Objective Elements classes:

    SingleTagStub =
      Struct.new(:name, :attributes)

    # Image handling backend:

    ImageStub =
      Struct.new(:width, :height)
  end
end
