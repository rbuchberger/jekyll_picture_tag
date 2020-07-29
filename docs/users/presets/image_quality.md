--- 
sort: 6
---

# Image Quality

## Quality

  _Format:_ `quality: 0 <= integer <= 100`

  _Example:_ `quality: 80`

  _Default:_ `75`

  Specify an image compression level for all image formats (where it makes
  sense, anyway).

## Format Quality

  _Format:_

  ```yaml
  format_quality:
    (format): 0 <= integer <= 100
    (...)
  ```

  _Example:_

  ```yaml
  format_quality:
    jpg: 75
    png: 65
    webp: 55
  ```

  _Default:_ quality setting

  Specify quality settings for various image formats, allowing you to take
  advantage of webp's better compression algorithm without trashing your jpg
  images (for example). If you don't give a setting for a particular format
  it'll fall back to the `quality` setting above, and if you don't set _that_
  it'll default to 75.
