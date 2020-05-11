FROM ruby:alpine
WORKDIR /root/jekyll_picture_tag
# Dependencies for nokogiri, eventmachine, and JPT
RUN apk add git imagemagick g++ musl-dev make libstdc++ zlib build-base
COPY Gemfile* jekyll_picture_tag.gemspec ./
COPY lib/jekyll_picture_tag/version.rb ./lib/jekyll_picture_tag/version.rb
RUN bundle install
COPY . .
CMD rake
