---
---

# How to use the Liquid Tag:

## Format:

{% raw %}
`{% picture [preset] (image) [crop] [alternate images & crops] [attributes] %}`
{% endraw %}

The only required argument is the base image. Line breaks and extra spaces are fine, and you can
use liquid variables anywhere.

## Examples:

{% raw %}
`{% picture example.jpg %}`

`{% picture thumbnail example.jpg 1:1 --alt Example Image %}`

`{% picture example.jpg 16:9 north --picture class="attribute-demo" %}`

`{% picture blog_index {{ post.image }} --link {{ post.url }} %}`

`{% picture "some example.jpg" mobile: other\ example.jpg %}`

```md
{% picture
  hero
  example.jpg 16:9 east
  tablet: example_cropped.jpg 3:2 east
  mobile: example_cropped_more.jpg 1:1-50+0 east
  --alt Happy Puppy
  --picture class="hero"
  --link /
%}
```

{% endraw %}

## Argument reference

Given in order:

- **Preset**

  Select a [markup preset]({{ site.baseurl }}/presets#markup-presets), or omit to use the `default` preset. Presets
  are collections of settings that determine nearly everything about JPT's output, from the image
  formats used to the exact format your markup will take.

- **Base Image** (Required)

  Can be any raster image (as long as you have the required ImageMagick delegate). Relative to
  jekyll's root directory, or the `source` [setting]({{ site.baseurl }}/global_configuration) if you've configured it.

  For filenames with spaces, either use double quotes (`"my image.jpg"`) or a backslash (`my\ image.jpg`).

- **Crop**

  **Check the [ installation guide ](installation) before using this feature.**

  Crop an image to a given aspect ratio or size. This argument is given as a `geometry` and
  (optionally) a `gravity`, which can appear in either order and are thin wrappers around
  ImageMagick's [geometry](http://www.imagemagick.org/script/command-line-processing.php#geometry)
  and [gravity](http://www.imagemagick.org/script/command-line-options.php#gravity) settings. The
  values given here will override the preset settings (if present), can be given after every image,
  and apply only to the preceding image.

  Geometry can take many forms, but most likely you'll want to set an aspect ratio-- given in the
  standard `width:height` ratio such as `3:2`. Gravity sets which portion of the image to keep, and
  is given in compass directions (`north`, `southeast`, etc) or `center` (default). Cropping happens
  before resizing; the preset `widths` setting is a post-crop value.

  If you'd like more fine-grained control, this can be offset by appending `+|-x` and (optionally)
  `y` pixel values to the _geometry_ (not the gravity!). Example: `1:1+400 west` means "Crop to a
  1:1 aspect ratio, starting 400 pixels from the left side.", and `north 3:2+0+100` means "Crop to
  3:2, starting 100 pixels from the top." These can get a bit persnickety; there's nothing to stop
  you from running off the side of the image. Pay attention.

  For detailed documentation, see ImageMagick's
  [crop](http://www.imagemagick.org/script/command-line-options.php#crop) tool.

  _Note:_ If you do a lot of trial and error with these, it's a good idea to manually delete your
  generated images folder more often as each change will build a new set of images without removing
  the old ones.

- **Alternate images**

  _Format:_ `(media query preset): (filename) (...)`

  _Example:_ `tablet: img_cropped.jpg mobile: img_cropped_more.jpg`

  Optionally specify any number of alternate base images for given [screen
  sizes]({{ site.baseurl }}/presets/#media-presets) (specified in `_data/picture.yml`). This is called [art
  direction](http://usecases.responsiveimages.org/#art-direction), and is one of JPT's strongest
  features.

  Give your images in order of ascending specificity (The first image is the most general). They will
  be provided to the browser in reverse order, and it will select the first one with an applicable
  media query.

- **Attributes**

  Optionally specify any number of HTML attributes, or an href target. These will be added to any
  attributes you've set in a preset.

  - **`--link`**

    _Format:_ `--link (some url)`

    _Examples_: `--link https://example.com`, `--link /blog/some_post/`

    Wrap the image in an anchor tag, with the `href` attribute set to whatever value you give it.
    This will override automatic source image linking, if you have enabled it.

    **Note**: If you get either mangled HTML or extra {::nomarkdown} tags when using this, read
    [here]({{ site.baseurl }}/notes).

  - **`--alt`**

    _Format:_ `--alt (alt text)`

    _Example:_ `--alt Here is my alt text!`

    Convenience shortcut for `--img alt="..."`

  - **`--(element)`**

    _Format:_ `--(picture|img|source|a|parent) (Standard HTML attributes)`

    _Example:_ `--img class="awesome-fade-in" id="coolio" --a data-awesomeness="11"`

    Apply attributes to a given HTML element. Your options are:

    - `picture`
    - `img`
    - `source`
    - `a` (anchor tag)
    - `parent`

    `--parent` will be applied to the `<picture>` if present, otherwise the `<img>`; useful when
    using an `auto` output format.
