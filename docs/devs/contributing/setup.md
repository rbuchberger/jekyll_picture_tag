---
sort: 1
---

## Setup

I use [asdf](https://github.com/asdf-vm/asdf) and [direnv](https://direnv.net/) (via
[asdf-direnv](https://github.com/asdf-community/asdf-direnv)). They add convenience, but they aren't
required and there are many alternatives available.

### With asdf & direnv:

```sh
$ git clone git@github.com:rbuchberger/jekyll_picture_tag.git
$ cd jekyll_picture_tag
$ direnv allow
$ asdf install
$ bundle install --binstubs
```

### Without asdf & direnv

```sh
$ git clone git@github.com:rbuchberger/jekyll_picture_tag.git
$ cd jekyll_picture_tag
$ bundle install
```

* The currently targeted ruby version is `2.5.8`; ensure your ruby version manager of choice knows
  about it. There's a `.ruby-version` file, which many will pick up automatically.
* If you add the project's `bin/` folder to your path, and run `bundle install --binstubs`, you won't
  have to use `bundle exec` for `rake` commands and such. See `.envrc` for one way to accomplish that.
