---
sort: 3
---

# Tests

The primary way to run these checks is `rake`:

| rake command                | function                        |
|-----------------------------|---------------------------------|
| `rake unit`                 | Unit tests only                 |
| `rake integration`          | Integration tests only          |
| `rake test`                 | Both unit and integration tests |
| `rake rubocop`              | Check code formatting           |
| `rake rubocop:auto_correct` | Fix rubocop issues, if possible |
| `rake`                      | Run all checks                  |

* Ignore the mini_magick `method redefined` warnings (unless you know how to fix them?) 
* Depending on your environment, you may need to prefix all rake commands with `bundle exec`
* Simplecov is set up -- you'll get a measurement of coverage in the test output and a nice report
  in the `coverage` directory.
* The tests use the `/tmp/` directory directly, which I'm pretty sure means it won't work on
  Windows. This is fixable, so if that gets in your way just ask.
