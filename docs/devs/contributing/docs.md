---
sort: 2
---

# Docs

The docs are a mini-project in the docs folder. They don't have a dedicated git repository, but they
do have their own Gemfile. They run on Github Pages, which is based on Jekyll.

The format is simple; markdown files with a few lines of metadata at the top, organized into
subdirectories. We're using the [jekyll-rtd-theme](https://jekyll-rtd-theme.rundocs.io/).

You can preview as you edit; first the setup:

``` sh
$ git clone https://github.com/rbuchberger/jekyll_picture_tag.git # if you haven't already
$ cd jekyll_picture_tag/docs
$ direnv allow # (optional)
$ bundle install --binstubs # --binstubs is optional.
```

If you use direnv or add `docs/bin` to your `PATH` another way, the `--binstubs` flag allows you to
skip `bundle exec`.

To preview:

``` sh
$ jekyll serve --livereload # (prefix with `bundle exec` if necessary)
```

* In a web browser, navigate to `localhost:4000/jekyll_picture_tag/`
