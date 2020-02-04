require 'test_helper'
class HTMLAttributeSetTest < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    build_defaults
    build_site_stub
    build_context_stub
    @preset = { 'attributes' => {} }
  end

  def tested(params = nil)
    PictureTag.stubs(:preset).returns(@preset)

    PictureTag::Instructions::HTMLAttributeSet.new(params)
  end

  def test_tag_attributes
    words = ['--picture', 'class="some-class other-class"']
    assert_equal 'class="some-class other-class"',
                 tested(words)['picture']
  end

  def test_preset_attributes
    @preset['attributes'] = { 'picture' => 'class="some-class other-class"' }

    assert_equal 'class="some-class other-class"',
                 tested['picture']
  end

  def test_both_attributes
    words = ['--picture', 'class="other-class"']
    @preset['attributes'] = { 'picture' => 'class="some-class"' }

    assert_equal 'class="some-class" class="other-class"',
                 tested(words)['picture']
  end

  def test_preset_empty_alt
    @preset['attributes']['img'] = 'alt=""'

    assert_equal 'alt=""', tested['img']
  end

  def test_tag_empty_alt
    words = ['--img', 'alt=""']

    assert_equal 'alt=""', tested(words)['img']
  end

  SourceStub = Struct.new(:shortname)
  UriStub = Struct.new(:to_s)
  def test_link_source
    @preset['link_source'] = true

    source_stub = SourceStub.new('some name')

    uri_stub = UriStub.new('correct answer')

    PictureTag.stubs(:source_images).returns([source_stub])
    ImgURI.stubs(:new).with('some name', source_image: true).returns(uri_stub)

    assert_equal 'correct answer', tested['link']
  end
end
