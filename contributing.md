# Contributing

Bug reports, feature requests, and feedback are very welcome, either through
github issues or via email: robert@buchberger.cc 

Pull requests are encouraged! I'm happy to answer questions and provide
assistance along the way. Don't let any of the recommendations/requests in this
guide stop you from submitting one; just allow modifications and I can take
care of a lot.

## Setup

Getting up and running is pretty standard-- `git clone`, `cd` into the
directory and `bundle install`.

## Testing

`rake test` or just `rake`. Ignore the mini_magick `method redefined` warnings
(unless you know how to fix them?) 

Simplecov is set up as well, you'll get a measurement of coverage in the test
output and a nice report in the `coverage` directory. I'd like to move to
mutation based coverage testing, but that's a project for another day.

The tests do output a few images to the `/tmp/` directory, which I'm pretty
sure means it won't work on Windows. This is fixable if there is a need, so if
that gets in your way just ask.

## Guidelines

* This project uses [rubocop](https://www.rubocop.org/en/stable/) for style and
  formatting enforcement, which has plugins for most text editors. It's
  installed as a development dependency, so if you don't want to bother with
  setting it up in your editor you can check for issues with `bundle exec
  rubocop`.

* Generally, go for straightforward and readable rather than terse and clever.
  I'm not actually a very good programmer; I need simple code that's easy to
  understand.

* Internal refactoring is welcome, especially in the name of the previous point.

* No changes which break existing liquid tag syntax. I'm not willing to force
  users to dig through their entire site and change every picture tag in order
  to update to the latest version.

* I'm very reluctant to introduce breaking changes to configuration settings.
  This rule isn't as hard and fast as the previous one, but I'm not going to do
  it without a good reason.

* If you add a new setting, it's helpful to add relevant documentation and a
  default value (if applicable, look under `lib/defaults/`). "No configuration
  required" is important.

* The addition of new test cases whenever relevant is certainly appreciated.
  This project went for awhile without any proper tests, but now that we're at
  100% coverage it would be nice to keep it that way. 

### Thanks!


