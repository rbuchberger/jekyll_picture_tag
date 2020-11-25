---
sort: 2
---

# Docs

They run on github pages, which is based on jekyll. You can preview as you edit; first the setup:

``` sh
$ git clone git@github.com:rbuchberger/jekyll_picture_tag.git # if you haven't already
$ cd jekyll_picture_tag/docs
$ direnv allow # (optional)
$ bundle install --binstubs
```

To preview: 

``` sh
$ jekyll serve --livereload # (prefix with `bundle exec` if necessary)
```

* In a web browser, navigate to `localhost:4000/jekyll_picture_tag/`
