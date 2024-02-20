require_relative 'output_format_test_helper'

class TestImg < Minitest::Test
  include OutputFormatTestHelper

  # Helpers

  def tested
    @tested ||= OutputFormats::Img.new
  end

  # Test cases

  def test_img
    correct = <<~HEREDOC
      <img src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_img_pixel_ratio
    PictureTag.preset.merge! pixel_ratio_preset
    stub_pixel_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="pixel srcset">
    HEREDOC
    assert_equal correct, tested.to_s
  end

  def test_width_srcset
    stub_width_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_srcset_and_sizes
    stub_sizes_srcset

    correct = <<~HEREDOC
      <img src="good_url" srcset="width srcset" sizes="correct sizes">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_alt
    PictureTag.html_attributes.merge!({ 'alt' => 'alt text' })

    correct = <<~HEREDOC
      <img src="good_url" alt="alt text" srcset="ss">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_parent
    PictureTag.html_attributes.merge!({ 'parent' => 'class="parent"' })

    correct = <<~HEREDOC
      <img src="good_url" srcset="ss" class="parent">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_img_attrs
    PictureTag.html_attributes.merge!({ 'img' => 'class="img"' })

    correct = <<~HEREDOC
      <img class="img" src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_both_attrs
    PictureTag.html_attributes.merge!({ 'img' => 'class="img"',
                                        'parent' => 'class="parent"' })

    correct = <<~HEREDOC
      <img class="img parent" src="good_url" srcset="ss">
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_anchor_tag
    PictureTag.html_attributes['link'] = 'some link'

    correct = <<~HEREDOC
      <a href="some link">
        <img src="good_url" srcset="ss">
      </a>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_anchor_with_attrs
    PictureTag.html_attributes.merge!({ 'link' => 'some link',
                                        'a' => 'class="anchor"' })

    correct = <<~HEREDOC
      <a class="anchor" href="some link">
        <img src="good_url" srcset="ss">
      </a>
    HEREDOC

    assert_equal correct, tested.to_s
  end

  def test_nomarkdown_wrapper
    PictureTag.stubs(nomarkdown?: true)
    PictureTag.html_attributes['link'] = 'some link'

    correct = <<~HEREDOC
      {::nomarkdown}<a href="some link"><img src="good_url" srcset="ss"></a>{:/nomarkdown}
    HEREDOC
    correct.delete!("\n")

    assert_equal correct, tested.to_s
  end
end
