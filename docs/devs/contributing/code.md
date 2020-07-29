---
sort: 4
---

# Code Guidelines

* Generally, go for straightforward and readable rather than terse and clever. I'm not actually a
  very good programmer; I need simple code that's easy to understand.

* Refactoring is welcome, especially in the name of the previous point.

* I'm very reluctant to introduce breaking changes to configuration settings. This rule isn't
  absolute, but I'm not going to do it without a good reason.

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
