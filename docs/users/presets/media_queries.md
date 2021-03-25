---
sort: 3
---

# Media Queries

Jekyll Picture Tag handles media queries by letting you define them by name in
`_data/picture.yml`, and then referencing that name whenever you need it.

_Format:_

```yaml
# _data/picture.yml

media_queries:
  (name): (css media query)
  (name): (css media query)
  (...)

```

_Example:_

```yaml
# _data/picture.yml

media_queries:
  mobile: "max-width: 600px"
  tablet: "max-width: 800px"
  ultrawide: "min-width: 1400px"
```

They are used in a few different places: specifying alternate source images in
your liquid tag, building the 'sizes' attribute within your presets, and in a
few configuration settings. Quotes are recommended, because yml gets confused by
colons.
