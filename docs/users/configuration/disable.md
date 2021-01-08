---
sort: 5
---

# Disable Jekyll Picture Tag

*Format:* `disabled: (true|false|environment|array of environments)`

*Examples:* 

  - `disabled: true`

  - `disabled: development`

  - `disabled: [development, staging]`

*Default:* `false`

Disable image and markup generation entirely. Useful for debugging, or to speed
up site builds when you're working on something else.

Hint: If you're going to toggle this frequently, you might use a Jekyll
Environment. Set this to something like `nopics`, and then start Jekyll with
`JEKYLL_ENV=nopics bundle exec jekyll serve`.
