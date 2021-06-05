---
sort: 1
---

## Setup

I use [asdf](https://github.com/asdf-vm/asdf) and [direnv](https://direnv.net/) (via
[asdf-direnv](https://github.com/asdf-community/asdf-direnv)). They add convenience, but they aren't
required by any means.

### With asdf & direnv:

```sh
$ git clone https://github.com/rbuchberger/jekyll_picture_tag.git
$ cd jekyll_picture_tag
$ direnv allow
$ asdf install
$ bundle install --binstubs
```

### Without asdf & direnv

```sh
$ git clone https://github.com/rbuchberger/jekyll_picture_tag.git
$ cd jekyll_picture_tag
# Install the correct version of ruby, with the bundler gem.
$ bundle install
```

* The currently targeted ruby version can be found in the `.ruby-version` file in the project root;
  ensure your version manager of choice knows about it.
* If you add the project's `bin/` folder to your path, and run `bundle install --binstubs`, you won't
  have to use `bundle exec` for `rake` commands and such.
