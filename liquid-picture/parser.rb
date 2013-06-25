require 'yaml'
require 'pry'

class Parser
  def initialize
    read_yaml
    #tag
  end

  def read_yaml
    YAML.load file_name
#    require 'pry'; binding.pry
  end

  def file_name
    'garbage'
  end
end
