# frozen_string_literal: true

# Appraisal definitions for testing against different Ruby and Jekyll versions

appraise 'ruby-2.6' do
  # Use Jekyll 4.0 which is compatible with Ruby 2.6
  gem 'jekyll', '~> 4.0.0'
  # Older rake for Ruby 2.6 compatibility
  gem 'rake', '~> 12.3'
end

appraise 'ruby-3.4' do
  # Use latest Jekyll 4.x for Ruby 3.4
  gem 'jekyll', '~> 4.3'
  # bigdecimal and ostruct are no longer default gems in Ruby 3.4+
  gem 'bigdecimal'
  gem 'ostruct'
end

appraise 'ruby-4.0' do
  # Use latest Jekyll 4.x for Ruby 4.0
  gem 'jekyll', '~> 4.3'
  # bigdecimal and ostruct are no longer default gems in Ruby 3.4+
  gem 'bigdecimal'
  gem 'ostruct'
end
