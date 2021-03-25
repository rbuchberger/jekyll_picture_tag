lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_picture_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll_picture_tag'
  spec.authors       = ['Robert Wierzbowski', 'Brendan Tobolaski',
                        'Robert Buchberger']
  spec.email         = ['robert@buchberger.cc']
  spec.homepage      = 'https://github.com/rbuchberger/jekyll_picture_tag'
  spec.metadata      = { 'documentation_uri' =>
                         'https://rbuchberger.github.io/jekyll_picture_tag/' }
  spec.license       = 'BSD-3-Clause'
  spec.summary       = 'Easy responsive images for Jekyll.'
  spec.description   = <<-HEREDOC
    Jekyll Picture Tag adds responsive images to your Jekyll static site. It
    automatically creates resized source images, is fully configurable, and
    covers all use cases, including art direction and resolution switching, with
    a little YAML configuration and a simple template tag.
  HEREDOC

  spec.version       = PictureTag::VERSION
  spec.require_paths = ['lib']
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end

  spec.required_ruby_version = ['>= 2.6', '< 4.0']

  # addressable is used to url-encode image filenames.
  spec.add_runtime_dependency 'addressable', '~> 2.6'
  # Jekyll versions older than 4.0 are not supported.
  spec.add_runtime_dependency 'jekyll', '~> 4.0'
  # MIME types are needed for <source> tags' type= attributes.
  spec.add_runtime_dependency 'mime-types', '~> 3.0'
  # objective_elements handles HTML generation.
  spec.add_runtime_dependency 'objective_elements', '~> 1.1'
  # rainbow is used to colorize terminal output.
  spec.add_runtime_dependency 'rainbow', '~> 3.0'
  # ruby-vips interfaces with libvips.
  spec.add_runtime_dependency 'ruby-vips', '~> 2.0.17'

  # libvips handles all image processing operations.
  spec.requirements << 'libvips'

  # Development dependencies are not installed when using this gem. You can
  # ignore these, unless you are working on JPT itself.
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'minitest-rg'
  spec.add_development_dependency 'mocha', '~> 1.9'
  spec.add_development_dependency 'nokogiri', '~> 1.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rubocop', '~> 1.7.0'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.10.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.0'
  spec.add_development_dependency 'simplecov', '~> 0.20.0'
  spec.add_development_dependency 'solargraph'
end
