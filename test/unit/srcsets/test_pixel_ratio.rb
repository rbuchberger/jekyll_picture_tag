require_relative 'srcsets_test_helper'

class TestSrcsetPixelRatio < Minitest::Test
  include SrcsetTestHelper

  def tested
    Srcsets::PixelRatio.new(source_image, 'original')
  end

  def config
    { keep: 'center', crop: nil, preset: {
      'pixel_ratios' => [1, 1.5, 2, 3],
      'base_width' => 100
    } }
  end

  def test_basic
    correct =
      '/img-100-aaaaa.jpg 1.0x, ' \
      '/img-150-aaaaa.jpg 1.5x, ' \
      '/img-200-aaaaa.jpg 2.0x, ' \
      '/img-300-aaaaa.jpg 3.0x'

    assert_equal correct, tested.to_s
  end
end
