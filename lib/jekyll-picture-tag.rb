# rubocop:disable Naming/FileName
puts '-' * 80
# rubocop:enable Naming/FileName

puts <<~HEREDOC
  \033[31;1;4m
  Important message from Jekyll Picture Tag:
  \033[0m
  Good news! We're back up on rubygems.
  Bad news. You need to update your Gemfile. Remove the following line:

  gem 'jekyll-picture-tag', git: 'https://github.com/robwierzbowski/jekyll-picture-tag/'

  and replace it with something like:

  gem 'jekyll_picture_tag', '~> 1.6'

  Sorry about that. For an explanation, see issue #120:
  https://github.com/rbuchberger/jekyll-picture-tag/issues/120

HEREDOC

puts '-' * 80

require 'jekyll_picture_tag'
