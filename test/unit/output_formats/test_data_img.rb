require_relative 'output_format_test_helper'

class TestDataImg < Minitest::Test
  include OutputFormatTestHelper

  # Helpers

  def tested
    @tested ||= OutputFormats::DataImg.new
  end

  # Test cases:

  def test_img
    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="ss">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_srcset_and_sizes
    stub_sizes_srcset

    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="width srcset" data-sizes="correct sizes">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_noscript
    PictureTag.preset['noscript'] = true
    PictureTag.stubs(nomarkdown: false)

    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="ss">
      <noscript>
        <img src="good_url">
      </noscript>

    HEREDOC

    assert_equal correct, tested.to_s
  end
end
