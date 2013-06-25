require 'mocha'
require File.join(File.dirname(__FILE__), '..', 'liquid-picturefill/parser')

Rspec.configure do |c|
  c.mock_with :mocha
end

describe Parser do

  describe '##initialize' do
    it 'reads a hard coded yaml file' do
      Parser.any_instance.expects(:read_yaml)
      Parser.new
    end
  end

  describe '#read_yaml' do
    it 'loads the correct file' do
      subject.stubs(file_name: 'fixtures/filter.yml')
      YAML.expects(:load).with('fixtures/filter.yml').returns(:blah)
      subject.read_yaml
    end
  end

  describe '#file_name' do
    it 'returns a garbage filename for now' do
      subject.file_name.should == 'garbage'
    end
  end

end
