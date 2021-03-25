---
sort: 3
---

# Presets

Presets are named collections of settings that determine basically everything
about JPT's output. Think of them like frameworks that you can plug images into;
the preset determines what markup, what image sizes, and what image formats to
create, while the picture tag determines which image(s) will be used.  They are
stored in `_data/picture.yml`. You will have to create this file, and probably
the `_data/` directory as well.

Any settings which are specific to particular markup formats are documented on
their respective markup format page.

_General Format:_

```yaml
# _data/picture.yml

presets:
  (name):
    (option): (setting)
    (option): (setting)
    (...)
  (...)
```

_Example:_

```yaml
# _data/picture.yml

presets:
  default:
    formats: [webp, original]
    widths: [200, 400, 800, 1600]
    link_source: true

  lazy:
    markup: data_auto
    widths: [200, 400, 800, 1600]
    link_source: true
    noscript: true
```

## Media Queries

**Media queries are not presets**, but they are used when writing them. They are
defined in `_data/picture.yml` alongside presets. They look like this:

```yaml
# _data/picture.yml

media_queries:
  (name): '(media query)'
  (name): '(media query)'
  (name): '(media query)'
```

Example:

```yaml
media_queries:
  full_width: 'min-width: 901px'
  tablet: 'min-width: 601px'
  mobile: 'max-width: 600px'
```

More information [here](media_queries).

## Reference

{% include list.liquid %}
