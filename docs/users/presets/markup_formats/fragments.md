---
sort: 3
---

# Fragments

The following are not complete markup; they're building blocks that you can use
to make things outside the scope of JPT.

- `direct_url` Generates an image and returns only its url. Uses
  `fallback_width` and `fallback_format`.

  ```yml
  # _data/picture.yml

  markup_presets:
    direct:
      markup: direct_url
      fallback_width: 800
      fallback_format: webp
  ```

  ```
  {% raw %}
  {% picture direct myimage.jpg %} --> /generated/myimage-800-abcd12345.webp
  {% endraw %}
  ```

- `naked_srcset`: Builds a srcset and nothing else (not even the surrounding quotes).

  ```yml
  # _data/picture.yml

  markup_presets:
    only_srcset:
      markup: naked_srcset
      widths: [800, 1200, 1600]
      formats: webp
  ```

  ```
  {% raw %}
  {% picture only_srcset myimage.jpg %} --> 
  /generated/myimage-800-abcd12345.webp 800w, /generated/myimage-1200-abcd12345.webp 1200w, (...)
  {% endraw %}
  ```
