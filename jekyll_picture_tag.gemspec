# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_picture_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll_picture_tag'
  spec.authors       = ['Robert Wierzbowski', 'Brendan Tobolaski',
                        'Robert Buchberger']
  spec.email         = ['robert@buchberger.cc']
  spec.homepage      = 'https://github.com/rbuchberger/jekyll_picture_tag'
  spec.metadata      = {
    'bug_tracker_uri' =>
      'https://github.com/rbuchberger/jekyll_picture_tag/issues',
    'changelog_uri' =>
      'https://github.com/rbuchberger/jekyll_picture_tag/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://rbuchberger.github.io/jekyll_picture_tag/',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rbuchberger/jekyll_picture_tag'
  }
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

  spec.required_ruby_version = '>= 3.0'

  # addressable is used to url-encode image filenames.
  spec.add_dependency 'addressable', '~> 2.6'
  # Jekyll versions older than 4.0 are not supported.
  spec.add_dependency 'jekyll', '>= 4.0'
  # MIME types are needed for <source> tags' type= attributes.
  spec.add_dependency 'mime-types', '~> 3.0'
  # objective_elements handles HTML generation.
  spec.add_dependency 'objective_elements', '~> 2.0'
  # rainbow is used to colorize terminal output.
  spec.add_dependency 'rainbow', '~> 3.0'
  # ruby-vips interfaces with libvips.
  spec.add_dependency 'ruby-vips', '~> 2.2'

  # libvips handles all image processing operations.
  spec.requirements << 'libvips'
  # The `vips` command-line utility comes from libvips-tools.
  spec.requirements << 'libvips-tools'

  # Development dependencies are declared in the Gemfile.
end
