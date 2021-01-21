# Tools to stub the jekyll and liquid interfaces
module Stubs
  include Presets
  include Structs

  def context
    @context ||= build_context
  end

  def build_context
    environments = [{ 'jekyll' => { 'environment' => jekyll_env } }]
    registers = { site: site, page: page }

    ContextStub.new(environments, registers)
  end

  def site
    @site ||= SiteStub.new(config_dot_yml, jekyll_data, site_source,
                           site_dest, cache_dir)
  end

  def jekyll_env
    @jekyll_env ||= 'development'
  end

  def site_dest
    @site_dest ||= temp_dir
  end

  # _config.yml
  def config_dot_yml
    @config_dot_yml ||= { 'picture' => pconfig,
                          'keep_files' => [],
                          'destination' => site_dest,
                          'url' => 'example.com' }
  end

  # picture: key in _config.yml
  def pconfig
    @pconfig ||= {}
  end

  # Loaded from _data/*.yml
  def jekyll_data
    @jekyll_data ||= { 'picture' => picture_dot_yml }
  end

  # _data/picture.yml
  def picture_dot_yml
    @picture_dot_yml ||= {
      'presets' => presets,
      'media_queries' => media_queries
    }
  end

  def page
    @page ||= { 'ext' => 'html' }
  end

  def site_source
    @site_source ||= File.join TestHelper::TEST_DIR, 'image_files'
  end

  def cache_dir
    @cache_dir ||= temp_dir('cache')
  end

  def stub_liquid
    stub_liquid_tag
    stub_template_parsing
  end

  def stub_liquid_tag
    Liquid::Template.stubs(:register_tag)
  end

  # Returns whatever params are originally passed in.
  def stub_template_parsing
    template_stub = Object.new
    Liquid::Template.stubs(:parse).with do |params|
      template_stub.stubs(:render).returns(params)
    end.returns(template_stub)
  end
end
