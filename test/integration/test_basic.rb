require_relative './test_integration_helper'

class TestIntegrationBasic < Minitest::Test
  include TestIntegrationHelper

  def setup
    base_stubs
    stub_console
  end

  def test_defaults
    correct = <<~HEREDOC
      <img src="/generated/rms-100-46a48b.jpg" srcset="/generated/rms-100-46a48b.jpg 100w">
    HEREDOC
    assert_equal tested, correct
    assert File.exist? rms_filename(width: 100)
  end

  def test_auto
    widths = [25, 50, 100]
    @pdata['markup_presets'] = {
      'default' => {
        'widths' => widths,
        'formats' => %w[webp original]
      }
    }

    correct = <<~HEREDOC
      <picture>
        <source srcset="/generated/rms-25-46a48b.webp 25w, /generated/rms-50-46a48b.webp 50w, /generated/rms-100-46a48b.webp 100w" type="image/webp">
        <source srcset="/generated/rms-25-46a48b.jpg 25w, /generated/rms-50-46a48b.jpg 50w, /generated/rms-100-46a48b.jpg 100w" type="image/jpeg">
        <img src="/generated/rms-100-46a48b.jpg">
      </picture>
    HEREDOC

    files = rms_file_array(widths, %w[webp jpg])
    assert_equal correct, tested
    assert(files.all? { |f| File.exist?(f) })
  end

  def test_complete_picture
    widths = [25, 50, 100]
    @pdata['markup_presets'] = {
      'picture_test' => {
        'widths' => widths,
        'formats' => %w[webp original],
        'sizes' => { 'mobile' => '80vw' },
        'size' => '400px'
      }
    }

    @pdata['media_presets'] = {
      'mobile' => 'max-width: 600px'
    }

    params = 'picture_test rms.jpg mobile: spx.jpg'

    correct = <<~HEREDOC
      <picture>
        <source sizes="(max-width: 600px) 80vw, 400px" media="(max-width: 600px)" srcset="/generated/spx-25-2e8bb3.webp 25w, /generated/spx-50-2e8bb3.webp 50w, /generated/spx-100-2e8bb3.webp 100w" type="image/webp">
        <source sizes="(max-width: 600px) 80vw, 400px" srcset="/generated/rms-25-46a48b.webp 25w, /generated/rms-50-46a48b.webp 50w, /generated/rms-100-46a48b.webp 100w" type="image/webp">
        <source sizes="(max-width: 600px) 80vw, 400px" media="(max-width: 600px)" srcset="/generated/spx-25-2e8bb3.jpg 25w, /generated/spx-50-2e8bb3.jpg 50w, /generated/spx-100-2e8bb3.jpg 100w" type="image/jpeg">
        <source sizes="(max-width: 600px) 80vw, 400px" srcset="/generated/rms-25-46a48b.jpg 25w, /generated/rms-50-46a48b.jpg 50w, /generated/rms-100-46a48b.jpg 100w" type="image/jpeg">
        <img src="/generated/rms-100-46a48b.jpg">
      </picture>
    HEREDOC

    formats = %w[webp jpg]
    files = rms_file_array(widths, formats) + spx_file_array(widths, formats)

    assert_equal correct, tested(params)
    assert(files.all? { |f| File.exist?(f) })
  end

  def teardown
    cleanup_files
  end
end
