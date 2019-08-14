---
---
# Contributing

Bug reports, feature requests, and feedback are very welcome, either through github issues or via
email: robert@buchberger.cc 

Pull requests are encouraged! I'm happy to answer questions and provide assistance along the way.
Don't let any of the recommendations/requests in this guide stop you from submitting one.

## Setup

Getting up and running is pretty standard-- `git clone`, `cd` into the directory and `bundle
install`.

## Testing

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

## Docs

The docs are set up for github pages, which is based on jekyll. You can preview them locally as you
edit:

1. `cd docs`
2. `bundle install`
3. `bundle exec jekyll serve`

## Guidelines

* Generally, go for straightforward and readable rather than terse and clever.  I'm not actually a
  very good programmer; I need simple code that's easy to understand.

* Internal refactoring is welcome, especially in the name of the previous point.

* I'm very reluctant to introduce breaking changes to configuration settings. This rule isn't
  absolute, but I'm not going to do it without a good reason.

* The addition of new test cases whenever relevant is certainly appreciated. This project went for
  awhile without any proper tests, but now that we're at 100% coverage it would be nice to keep it
  that way. 

* I've been using 80 characters for code and 100 characters for documentation.

## Hard rules

* Liquid tag syntax can only be extended; no breaking changes. I'm not willing to force
  users to dig through their entire site and change every picture tag in order to update to the
  latest version.

* Maintain "no configuration required" - a new user must be able to add jpt to their gemfile, bundle
  install, and start writing picture tags in their site without touching a yml file.

* All tests pass, and all rubocop warnings are addressed.

### Thanks!

As I said, don't let any of the rules & guidelines scare you away. They're the rules for merging
into master, not submitting a pull request. I'm thrilled to receive any help at all.
