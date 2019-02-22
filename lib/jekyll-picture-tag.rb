puts '-'*80

puts <<-HEREDOC

Message from Jekyll Picture Tag:

Good news! We're back up on rubygems. 
Bad news. You need to update your gemfile. Sorry about that. We had to rename
the whole gem. For an explanation, see issue #120:
https://github.com/robwierzbowski/jekyll-picture-tag/issues/120

In your gemfile, remove the 'jekyll-picture-tag' line, replace it with:

gem 'jekyll_picture_tag', '~> 1.2'

HEREDOC

puts '-'*80

require_relative 'jekyll_picture_tag'
