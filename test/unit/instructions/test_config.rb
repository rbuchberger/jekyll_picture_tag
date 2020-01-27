require 'test_helper'
class ConfigTest < Minitest::Test
  include PictureTag
  include TestHelper
  include JekyllStub

  def setup
    build_defaults

    @site_source = 'jekyll_source'
    @site_dest = 'jekyll_dest'
    @pconfig['source'] = 'jpt_source'
    @pconfig['output'] = 'jpt_dest'

    build_site_stub
    build_context_stub
  end

  def tested
    PictureTag.stubs(:context).returns(@context)
    PictureTag.stubs(:site).returns(@site)

    PictureTag::Instructions::Configuration.new
  end

  def test_defaults
    assert tested['picture']['relative_url']
  end

  def test_nomarkdown_on
    Utils.stubs(:markdown_page?).returns(true)

    assert tested.nomarkdown?
  end

  def test_nomarkdown_off
    Utils.stubs(:markdown_page?).returns(true)
    @pconfig['nomarkdown'] = false

    refute tested.nomarkdown?
  end

  def test_source_dir
    assert_equal 'jekyll_source/jpt_source', tested.source_dir
  end

  def test_dest_dir
    assert_equal 'jekyll_dest/jpt_dest', tested.dest_dir
  end

  def test_missing_string
    @pconfig['ignore_missing_images'] = 'development'

    assert tested.continue_on_missing?
  end

  def test_missing_array
    @pconfig['ignore_missing_images'] = ['development']

    assert tested.continue_on_missing?
  end

  def test_missing_bool
    @pconfig['ignore_missing_images'] = true

    assert tested.continue_on_missing?
  end

  def test_missing_default
    refute tested.continue_on_missing?
  end

  def test_continue_bad_arg
    @pconfig['ignore_missing_images'] = 42

    assert_raises ArgumentError do
      tested.continue_on_missing?
    end
  end

  def test_cdn
    @pconfig['cdn_url'] = 'some cdn'
    @pconfig['cdn_environments'] = %w[development production]

    assert tested.cdn?
  end

  def test_cdn_wrong_env
    @pconfig['cdn_url'] = 'some cdn'
    @pconfig['cdn_environments'] = %w[production]

    refute tested.cdn?
  end

  def test_cdn_default
    @pconfig['cdn_environments'] = ['development']

    refute tested.cdn?
  end

  def test_disabled_bool
    @pconfig['disabled'] = true

    assert tested.disabled?
  end

  def test_disabled_string
    @pconfig['disabled'] = 'development'

    assert tested.disabled?
  end

  def test_disabled_array
    @pconfig['disabled'] = ['production']

    refute tested.disabled?
  end

  def test_disabled_bad_arg
    @pconfig['disabled'] = 42

    assert_raises ArgumentError do
      tested.disabled?
    end
  end
end
