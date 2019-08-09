# Since we have two gemfiles, we can't just require 'bundler/gem_tasks'. We have
# to explicitly set its name and install them:

require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks name: 'jekyll_picture_tag'
require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

RuboCop::RakeTask.new

task default: :test
