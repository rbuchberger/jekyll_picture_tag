--- 
sort: 6
---

# Image Quality

Image quality can be as simple as a constant for all images, or can be varied based on image width
and output format.

```note
For lossless webp images, set quality to 100.
```


## Quality

### Constant

  _Format:_ `quality: 0 <= integer <= 100`

  _Example:_ `quality: 80`

  _Default:_ `75`

  Specify an image compression level for all widths, all image formats.

### Variable

  _Format:_ 

```yaml
  quality: 
    (image width): (quality setting)
    (image width): (quality setting) 
```

  _Example:_ 

```yaml
  quality: 
    1000: 65
    300: 100
```

Set a variable image quality, based on image width. Provide exactly 2 image widths and associated
quality settings. Quality will be calculated as follows:

  * For images smaller than the lowest image width, the setting for the lowest width is used. 
  * For images larger than the highest image width, the setting for the highest width is used. 
  * For images in between the 2, the quality setting will be linearly interpolated to some value in
    between.

  ![](quality_width_graph.png)

Using this setting, you can get away with more compression on high pixel density screens without
sacrificing image quality for low-density screens. Taking the example settings above:

  * A 1500px image will use a quality of 65.
  * A 200px image will use a quality of 100.
  * A 500px image will use a quality of 90.


## Format Quality

  _Format:_

  ```yaml
  format_quality:
    (format): 0 <= integer <= 100
    (...)
  ```

  ```yaml
    format_quality: 
      (format):
        (image width): (quality setting)
        (image width): (quality setting) 
  ```


  _Example:_

  ```yaml
  format_quality:
    jpg: 75
    png: 65
    webp: 55
  ```

  ```yaml
    format_quality: 
      jpg:
        1000: 65
        300: 100
      (...)
  ```

  _Default:_ quality setting

  Specify quality settings for various image formats, allowing you to take advantage of webp's
  better compression algorithm without trashing your jpg images (for example). If you don't give a
  setting for a particular format it'll fall back to the `quality` setting above, and if you don't
  set _that_ it'll default to 75. 

  Note that this setting can accept the same variable quality setting format as the basic `quality` setting.
