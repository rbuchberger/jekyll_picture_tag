---
sort: 3
---

## How to run the tests

You probably only need to use docker if it's inconvenient to install ImageMagick 7.

### Bare Metal

```note
Depending on your environment, you may need to prefix all rake commands with
`bundle exec`.
```

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

The following commands will build and run the tests inside a docker image.

```bash
$ docker build . -t jpt
$ docker run -t jpt
```
