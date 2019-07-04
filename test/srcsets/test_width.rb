require 'test_helper'

class TestSrcsetWidth < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    @source_image = SourceImageStub.new(width: 1000, shortname: 'some name')

    PictureTag.stubs(:source_images).returns(
      'mobile' => @source_image
    )

    @tested = Srcsets::Width.new(
      media: 'mobile',
      format: 'some format'
    )
  end

  # to_a
  def test_to_a
    @tested.expects(:widths).returns([100])
    @tested.expects(:build_srcset_entry).with(100).returns('correct')
    assert_equal ['correct'], @tested.to_a
  end

  # sizes
  def test_sizes_existing
    PictureTag.stubs(:preset).returns(
      'sizes' => { 'media1' => 'size1', 'media2' => 'size2' },
      'size' => 'correct3'
    )

    @tested.expects(:build_size_entry)
           .with('media1', 'size1').returns('correct1')
    @tested.expects(:build_size_entry)
           .with('media2', 'size2').returns('correct2')

    assert_equal 'correct1, correct2, correct3', @tested.sizes
  end

  def test_sizes_none
    PictureTag.stubs(:preset).returns({})

    assert_nil @tested.sizes
  end

  # widths
  def test_widths
    PictureTag.expects(:widths).returns('something')
    @tested.expects(:check_widths).with('something')

    @tested.send(:widths)
  end

  # build_srcset_entry
  def test_build_srcset_entry
    file_stub = GeneratedImageStub.new(name: 'good name', width: 100)
    PictureTag.expects(:build_url).with('good name').returns('good url')

    @tested.expects(:generate_file).with(100).returns(file_stub)
    assert_equal 'good url 100w', @tested.send(:build_srcset_entry, 100)
  end

  # build_size_entry
  def test_build_size_entry
    PictureTag.expects(:media_presets).returns('good name' => 'good media')

    assert_equal '(good media) good size', @tested.send(:build_size_entry,
                                                        'good name',
                                                        'good size')
  end
end
