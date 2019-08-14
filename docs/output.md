---
---

# Output Formats

This is a listing of the various text arrangements that JPT can give you. Select one by setting
`markup:` in the relevant [markup preset]({{ site.baseurl }}/presets).

Example: 

```yml
# /_data/picture.yml

markup_presets:
  my_preset:
    markup: data_auto
```

## Standard HTML:

* **`picture`:** `<picture>` element surrounding a `<source>` tag for each required srcset, and a
  fallback `<img>`.

* **`img`:** output a single `<img>` tag with a `srcset` entry.

* **`auto`:** Supply an img tag when you have only one srcset, otherwise supply a picture tag.

## Javascript Friendly:

* **`data_picture`, `data_img`, `data_auto`:** Analogous to their counterparts, but instead of
`src`, `srcset`, and `sizes`, you get `data-src`, `data-srcset`, and `data-sizes`. This allows you
to use javascript for things like [lazy loading](https://github.com/verlok/lazyload). Include a
basic `img` fallback within a `<noscript>` tag by setting `noscript: true` in the preset. This
allows you to keep working images for your non-javascript-enabled users.

  *Example:* 

  ```yml
  # /_data/picture.yml
  markup_presets:
    lazy: 
      markup: data_auto
      noscript: true
  ```

## Fragments:

* `direct_url`: Generates an image and returns only its url. Uses `fallback_` properties (width
and format).

* `naked_srcset`: Builds a srcset and nothing else (not even the surrounding quotes). Note that the
(image) `format` setting must still be an array, even if you only give it one value.
