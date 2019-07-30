require 'test_helper'
module TestIntegrationHelper
  include TestHelper
  include PictureTag

  # PictureTag inherits from a basic Liquid tag, which helps it to interact with
  # jeckyll but isn't necessary to test our code.

  ContextStub = Struct.new(:environments, :registers)
  SiteStub = Struct.new(:config, :data, :source, :dest)
  TokenStub = Struct.new(:line_number, :locale)

  def tested(params = 'rms.jpg')
    Nokogiri::HTML(tested_base(params))
  end

  def tested_base(params = 'rms.jpg')
    PictureTag::Picture
      .send(:new, 'picture', params, TokenStub.new(true, 'some stub'))
      .render(@context)
  end

  def rms_filename(width: 100, format: 'jpg')
    '/tmp/jpt' + rms_url(width: width, format: format)
  end

  def rms_url(width: 100, format: 'jpg')
    "/generated/rms-#{width}-46a48b.#{format}"
  end

  def spx_url(width: 100, format: 'jpg')
    "/generated/spx-#{width}-2e8bb3.#{format}"
  end

  def spx_filename(width: 100, format: 'jpg')
    '/tmp/jpt' + spx_url(width: width, format: format)
  end

  def rms_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| rms_filename(width: w, format: f) }
    end

    files.flatten
  end

  def std_spx_ss
    '/generated/spx-25-2e8bb3.jpg 25w,' \
       ' /generated/spx-50-2e8bb3.jpg 50w, /generated/spx-100-2e8bb3.jpg 100w'
  end

  def std_rms_ss
    '/generated/rms-25-46a48b.jpg 25w,' \
      ' /generated/rms-50-46a48b.jpg 50w, /generated/rms-100-46a48b.jpg 100w'
  end

  def spx_file_array(widths, formats)
    files = formats.collect do |f|
      widths.collect { |w| spx_filename(width: w, format: f) }
    end

    files.flatten
  end

  def base_stubs
    build_defaults
    build_site_stub
    build_context_stub
    stub_liquid
  end

  # Since Nokogiri apparently still doesn't know about HTML5, we have to
  # ignore 'invalid tag errors' which have an 801 code (I think):
  def errors_ok?(output)
    output.errors.none? { |e| e.code != 801 }
  end

  def stub_console
    PictureTag::GeneratedImage.any_instance.stubs(:puts)
    PictureTag::Utils.stubs(:warning)
  end

  def build_context_stub
    environments = [{ 'jekyll' => { 'environment' => @jekyll_env } }]
    registers = {
      site: @site,
      page: @page
    }

    @context = ContextStub.new(environments, registers)
  end

  def build_defaults
    @widths = [25, 50, 100]
    @pconfig = {}
    @pdata = {
      'markup_presets' => {
        'default' => {
          'widths' => @widths
        },

        'auto' => {
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_auto' => {
          'markup' => 'data_auto',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_img' => {
          'markup' => 'data_img',
          'widths' => @widths
        },

        'data_picture' => {
          'markup' => 'data_picture',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'direct_url' => {
          'markup' => 'direct_url',
          'fallback_width' => 100
        },

        'img' => {
          'markup' => 'img',
          'widths' => @widths
        },

        'naked_srcset' => {
          'markup' => 'naked_srcset',
          'widths' => @widths
        },

        'sizes' => {
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%'
        },

        'pixel_ratio' => {
          'base_width' => 10,
          'pixel_ratios' => [1, 2, 3]
        },

        'attributes' => {
          'formats' => %w[webp original],
          'widths' => @widths,
          'attributes' => {
            'parent' => 'class="parent"',
            'alt' => 'Alternate Text',
            'a' => 'class="anchor"',
            'picture' => 'data-awesomeness="11"',
            'source' => 'class="source"',
            'img' => 'class="img"'
          }
        },

        'link_source' => {
          'widths' => @widths,
          'link_source' => true
        },

        'media_widths' => {
          'widths' => @widths,
          'media_widths' => {
            'mobile' => [10, 20, 30]
          }
        },

        'data_noscript' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'noscript' => true
        },

        'fallback' => {
          'widths' => @widths,
          'fallback_width' => 35,
          'fallback_format' => 'webp'
        },

        'nomarkdown' => {
          'widths' => @widths,
          'nomarkdown' => true
        }
      },

      'media_presets' => {
        'mobile' => 'max-width: 600px'
      }

    }

    @jekyll_env = 'development'
    @jconfig = { 'picture' => @pconfig, 'keep_files' => [] }
    @data = { 'picture' => @pdata }
    @page = { 'ext' => 'html' }
    @site_source = TEST_DIR
    @site_dest = '/tmp/jpt'
  end

  def build_site_stub
    @site = SiteStub.new(
      @jconfig, @data, @site_source, @site_dest
    )
  end

  def stub_liquid
    Liquid::Template.stubs(:register_tag)

    # Liquid::Template.parse(params).render(context)
    template_stub = Object.new
    Liquid::Template.stubs(:parse).with do |params|
      template_stub.define_singleton_method(:render) { |_context| params }
    end.returns(template_stub)
  end

  def cleanup_files
    FileUtils.rm_rf('/tmp/jpt/')
  end
end
