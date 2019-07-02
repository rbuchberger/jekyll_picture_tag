require 'yaml'

# Gives us a hash to work with as a stub of jekyll itself.
class JekyllStub
  def initialize(yaml_file = './site.yml')
    @content = YAML.autoload(File.read(yaml_file))
  end

  def [](key)
    @content[key]
  end

  def []=(key, value)
    @content[key] = value
  end
end
