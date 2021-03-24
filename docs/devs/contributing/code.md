---
sort: 4
---

# Code

## Commit guidelines

* The commit log should be a history of small, coherent changes. Commits are cheap, make no attempt
  to minimize the number of them! Yes, it's messy. Yes it makes the commit log longer. It's also far
  more useful than a nice, tidy, one-commit-per-pull-request log.

* Follow the existing commit message style. Start with a capitalized, present tense verb and say
  what the commit does. If the reason why isn't obvious, explain in the extended message.

## Code Guidelines

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

* Good test coverage, > 90%. Not every line must be tested, but every line that matters should be.

* No failing tests

* No rubocop warnings

## Thanks!

As I said, don't let any of the rules & guidelines scare you away. They're the rules for merging
into master, not submitting a pull request. I'm thrilled to receive any help at all.
