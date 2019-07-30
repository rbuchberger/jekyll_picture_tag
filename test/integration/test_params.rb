require_relative './test_integration_helper'

# This is for testing various tag params. It pulls in presets to make sure
# they're checked correctly, but it's focused on tag arguments.
class TestIntegrationParams < Minitest::Test
  include TestIntegrationHelper

  def setup
    base_stubs
    stub_console
  end

  def teardown
    cleanup_files
  end

  # Basic functionality test, default settings
  def test_defaults
    output = tested
    assert output.errors.empty?

    img = output.at_css('img')

    assert_equal rms_url, img['src']
    assert_equal rms_url + ' 100w', img['srcset']
    assert File.exist? rms_filename
  end

  # Make sure it doesn't overwrite existing files
  def test_with_existing
    FileUtils.mkdir_p '/tmp/jpt/generated'
    FileUtils.touch rms_filename
    MiniMagick::Image.expects(:open).never

    tested
  end

  def test_attributes
    params = <<~HEREDOC
      auto rms.jpg class="implicit" --parent class="parent" --picture
       data-awesomeness="11" --img class="img" --source class="source"
       --alt Alternate Text
    HEREDOC

    output = tested(params)
    assert errors_ok? output

    pic = output.at_css('picture')
    img = output.at_css('img')
    sources = output.css('source')

    assert_equal 'parent', pic['class']
    assert_equal '11', pic['data-awesomeness']
    assert_equal 'Alternate Text', img['alt']
    assert img['class'].include? 'implicit'
    assert img['class'].include? 'img'
    assert(sources.all? { |s| s['class'] == 'source' })
  end

  def test_link
    output = tested 'rms.jpg --link example.com'

    refute output.errors.any?
    assert_equal 'example.com', output.at_css('a')['href']
    assert output.at_css('a').children.include? output.at_css('img')
  end
end
