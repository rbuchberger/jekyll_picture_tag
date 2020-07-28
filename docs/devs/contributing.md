---
---
# Contributing

Bug reports, feature requests, and feedback are very welcome, either through github issues or via
email: robert@buchberger.cc 

Pull requests are encouraged! I'm happy to answer questions and provide assistance along the way.
Don't let any of the recommendations/requests in this guide stop you from submitting one.

## Setup

It's pretty standard:

```
$ git clone git@github.com:rbuchberger/jekyll_picture_tag.git
$ cd jekyll_picture_tag
$ bundle install
```

## Testing

You probably only need to use docker if it's inconvenient to install ImageMagick 7.

### Bare Metal

`rake test` runs the test suite (both unit tests and integration tests). Ignore the mini_magick
`method redefined` warnings (unless you know how to fix them?) 

`rake unit` runs just the unit tests, while `rake integration` runs the integration tests. The unit
test coverage isn't stellar, but both unit and integration tests together hit 100%.

Speaking of coverage, simplecov is set up -- you'll get a measurement of coverage in the test output
and a nice report in the `coverage` directory. I'd like to move to mutation based coverage testing,
but that's a project for another day.

The tests do output a few images to the `/tmp/` directory, which I'm pretty sure means it won't work
on Windows. This is fixable if there is a need, so if that gets in your way just ask.

`rake rubocop` checks code formatting, `rake rubocop:auto_correct` will try to fix any rubocop
issues, if possible.

`rake` will run all tests and rubocop.

### Docker

The following commands will build and run the tests inside a docker image. This is useful if it's
inconvenient to install ImageMagick 7, or to ensure the Travis CI build will succeed:

```
$ docker build . -t jpt
$ docker run -t jpt
```

## Docs

I think one of the biggest opportunities for improvement in this plugin is its documentation. I'd
 really love help here, and all you need to know is markdown.

It runs on github pages, which is based on jekyll. You can preview as you edit:

0. Follow setup instructions above
1. `$ cd docs`
2. `$ bundle install`
3. `$ bundle exec jekyll serve`
4. In a web browser, navigate to `localhost:4000/jekyll_picture_tag/`

## Code Guidelines

* Generally, go for straightforward and readable rather than terse and clever. I'm not actually a
  very good programmer; I need simple code that's easy to understand.

* Refactoring is welcome, especially in the name of the previous point.

* I'm very reluctant to introduce breaking changes to configuration settings. This rule isn't
  absolute, but I'm not going to do it without a good reason.

* I've been using 80 characters for code and 100 characters for documentation.

* Don't disable cops without strong justification.

* I generally try to write tests before writing code, especially when fixing bugs. This
  gives us some confidence that what we think we're testing and what we're actually testing aren't
  too different.

## Hard rules

These aren't the rules for submitting a pull request, these are the rules for merging into master.
I'm thrilled to receive any help at all, and I'm more than happy to help with meeting these
criteria:

* Liquid tag syntax can only be extended; no breaking changes. I'm not willing to force
  users to dig through their entire site and change every picture tag in order to update to the
  latest version.

* Maintain "no configuration required" - a new user must be able to add JPT to their gemfile, bundle
  install, and start writing picture tags in their site without touching a yml file.

* 100% test coverage (Meaning that when running the unit and integration tests together, every line
  of code in the `lib` folder must run at least once.)

* No failing tests

* No rubocop warnings

### Thanks!

As I said, don't let any of the rules & guidelines scare you away. They're the rules for merging
into master, not submitting a pull request. I'm thrilled to receive any help at all.
