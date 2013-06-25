require 'yaml'
require 'pry'

class Parser
  def initialize
    read_yaml
    #tag
  end

  def read_yaml
    file = YAML.load_file file_name
  end

  def file_name
    'notes/_config.yml'
  end
end
