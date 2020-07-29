---
sort: 6
---

# Attributes

Optionally specify any number of HTML attributes. These will be combined with
any which you've set in a preset.

All arguments which begin with `--` (including `--link`) must be at the end of
the liquid tag, but they can be given in any order.

- **`--alt`**

  _Format:_ `--alt (alt text)`

  _Example:_ `--alt Here is my alt text!`

  Convenience shortcut for `--img alt="..."`

- **`--(element)`**

  _Format:_ `--(picture|img|source|a|parent) (Standard HTML attributes)`

  _Example:_ `--img class="awesome-fade-in" id="coolio" --a data-awesomeness="11"`

  Apply attributes to a given HTML element. Your options are:

  - `--picture`
  - `--img`
  - `--source`
  - `--a` (anchor tag)
  - `--parent`

`--parent` will be applied to the `<picture>` if present, otherwise the
`<img>`; useful when using an `auto` output format.

```note
Attributes that are set here for elements which don't occur in the selected
markup format will be ignored (e.g. adding `--picture class="cool-css"` with a
preset that does not use a `<picture>` tag).
```
