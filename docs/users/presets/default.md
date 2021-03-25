---
sort: 14
---

# Default preset

Here are the default preset settings:

```yml
presets:
  default:
    markup: auto
    formats: [original]
    widths: [400, 600, 800, 1000]
    fallback_width: 800
    fallback_format: original
    noscript: false
    link_source: false
    quality: 75
    format_quality:
      webp: 50
      avif: 30
      jp2: 30
    strip_metadata: true
    image_options:
      avif:
        compression: av1
        speed: 8
    data_sizes: true
    keep: attention
    dimension_attributes: false
```
