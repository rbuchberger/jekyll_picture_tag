# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "jekyll-picture-tag"
  spec.version       = '0.3.0'
  spec.authors       = ['Robert Wierzbowski', "Brendan Tobolaski"]
  spec.email         = ['hello@robwierzbowski.com', "brendan@tobolaski.com"]

  spec.summary       = %q{Easy responsive images for Jekyll.}
  spec.description   = <<-EOF
    Jekyll Picture Tag is a liquid tag that adds responsive images to your Jekyll static site. It follows the picture
    element pattern, and polyfills older browsers with Picturefill. Jekyll Picture Tag automatically creates resized
    source images, is fully configurable, and covers all use cases — including art direction and resolution switching —
    with a little YAML configuration and a simple template tag.
  EOF
  spec.homepage      = 'https://github.com/robwierzbowski/jekyll-picture-tag'
  spec.license       = 'BSD-3-Clause'
  spec.require_paths = ['lib']


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'mini_magick', '~> 4.5.0'
  spec.add_dependency 'fastimage', '~> 2.0.1'
  spec.add_runtime_dependency 'jekyll', '< 4'
end
