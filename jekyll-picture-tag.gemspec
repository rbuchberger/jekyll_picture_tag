lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_picture_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-picture-tag'
  spec.version       = PictureTag::VERSION
  spec.authors       = ['Robert Wierzbowski', 'Brendan Tobolaski',
                        'Robert Buchberger']
  spec.email         = ['robert@buchberger.cc']

  spec.summary       = 'Easy responsive images for Jekyll.'
  spec.description   = <<~HEREDOC
     ____                                _           _
    |  _ \  ___ _ __  _ __ ___  ___ __ _| |_ ___  __| |
    | | | |/ _ \ '_ \| '__/ _ \/ __/ _` | __/ _ \/ _` |
    | |_| |  __/ |_) | | |  __/ (_| (_| | ||  __/ (_| |
    |____/ \___| .__/|_|  \___|\___\__,_|\__\___|\__,_|
               |_|

    This gem has been renamed! Use jekyll_picture_tag instead, which is now
    hosted on rubygems.
  HEREDOC
  spec.homepage      = 'https://github.com/rbuchberger/jekyll-picture-tag'
  spec.license       = 'BSD-3-Clause'
  spec.require_paths = ['lib']

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = ['>= 2.5', '< 3']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3'

  spec.add_dependency 'fastimage', '~> 2'
  spec.add_dependency 'mime-types', '~> 3'
  spec.add_dependency 'mini_magick', '~> 4'
  spec.add_dependency 'objective_elements', '~> 1.1'

  spec.add_runtime_dependency 'jekyll', '< 5'
end
