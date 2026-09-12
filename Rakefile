# frozen_string_literal: true

# Since we have two gemfiles, we can't just require 'bundler/gem_tasks'. We have
# to explicitly set its name and install them:

require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks name: 'jekyll_picture_tag'
require 'rake/testtask'

# Run all tests
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

# Run only unit tests
Rake::TestTask.new(:unit) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/unit/**/test_*.rb']
end

# Run only integration tests
Rake::TestTask.new(:integration) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/integration/**/test_*.rb']
end

LINT_GEMFILE = File.expand_path('gemfiles/lint.gemfile', __dir__)

desc 'Run RuboCop'
task :rubocop do
  Bundler.with_unbundled_env do
    env = { 'BUNDLE_GEMFILE' => LINT_GEMFILE }
    sh(env, 'bundle', 'check') { |ok, _| sh(env, 'bundle', 'install') unless ok }
    sh(env, 'bundle', 'exec', 'rubocop')
  end
end

# Runs all tests and rubocop
task default: %i[test rubocop]
