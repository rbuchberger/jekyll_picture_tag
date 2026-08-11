---
sort: 4
---

# Code

## Commit guidelines

- [Scoped commits](https://scopedcommits.com/)
- The commit log should be a history of small, coherent changes.

## Code Guidelines

- I'm very reluctant to introduce breaking changes to configuration settings. This rule isn't
  absolute, but I'm not going to do it without a good reason.
- Don't disable cops without strong justification.

## Hard rules

These aren't the rules for submitting a pull request, these are the rules for merging into master.
I'm thrilled to receive any help at all, and I'm more than happy to help with meeting these
criteria:

- Liquid tag syntax can only be extended; no breaking changes. I'm not willing to force
  users to dig through their entire site and change every picture tag in order to update to the
  latest version.
- Maintain "no configuration required" - a new user must be able to add JPT to their gemfile, bundle
  install, and start writing picture tags in their site without touching a yml file.
- No failing tests
- No rubocop warnings

## Thanks

As I said, don't let any of the rules & guidelines scare you away. They're the rules for merging
into master, not submitting a pull request. I'm thrilled to receive any help at all.
