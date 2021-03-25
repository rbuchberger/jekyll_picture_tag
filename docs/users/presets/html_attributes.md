---
sort: 10
---

# Arbitrary HTML Attributes

_Format:_

```yaml
attributes:
  (element): '(attributes)'
  (...)
```

_Example:_

```yaml
attributes:
  img: 'class="soopercool" data-awesomeness="11"'
  picture: 'class="even-cooler"'
```

HTML attributes you would like to add. The same arguments are available here as
in the liquid tag: HTML element names, `alt:`, `link:`, and `parent:`. Unescaped
double quotes cause problems with yml, so it's recommended to surround them with
single quotes.
