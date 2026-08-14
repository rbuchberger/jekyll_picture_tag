# frozen_string_literal: true

require 'test_helper'

class TestConfiguration < Minitest::Test
  include PictureTag

  def stub_config(config)
    PictureTag.stubs(site: Object.new)
    PictureTag.site.stubs(config: config)
  end

  def tested
    Parsers::Configuration.new
  end

  def test_default_values
    stub_config({})

    assert_equal 'generated', tested['picture']['output']
  end

  # Setting one picture config key must not discard the others.
  def test_deep_merges_picture_config
    stub_config('picture' => { 'output' => 'img' })

    assert_equal 'img', tested['picture']['output']
    assert_equal false, tested['picture']['suppress_warnings']
  end

  # Jekyll's own config keys pass through untouched.
  def test_keeps_unrelated_jekyll_settings
    stub_config('destination' => '_site')

    assert_equal '_site', tested['destination']
  end
end
