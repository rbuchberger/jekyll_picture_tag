---
---
# How to use the Liquid Tag:

## Format:

{% raw %}
`{% picture [preset] (base image) [alternate images] [attributes] %}`
{% endraw %}

The only required argument is the base image. Line breaks and extra spaces are fine, and you can
use liquid variables anywhere.

## Examples:

{% raw %}
`{% picture example.jpg %}`

`{% picture thumbnail example.jpg --alt Example Image %}`

`{% picture example.jpg --picture class="attribute-demo" %}`

`{% picture blog_index {{ post.image }} --link {{ post.url }} %}`

`{% picture "some example.jpg" mobile: other\ example.jpg %}`

```md
{% picture 
  hero 
  example.jpg 
  tablet: example_cropped.jpg
  mobile: example_cropped_more.jpg 
  --alt Happy Puppy 
  --picture class="hero" 
  --link /
%}
```
{% endraw %}

## Argument reference

Given in order:

* **Preset**

  Select a [markup preset]({{ site.baseurl }}/presets#markup-presets), or omit to use the `default` preset. Presets
  are collections of settings that determine nearly everything about JPT's output, from the image
  formats used to the exact format your markup will take.

* **Base Image** (Required)

  Can be any raster image (as long as you have the required ImageMagick delegate). Relative to
  jekyll's root directory, or the `source` [setting]({{ site.baseurl }}/global_configuration) if you've configured it.

  For filenames with spaces, either use double quotes (`"my image.jpg"`) or a backslash (`my\
  image.jpg`).

* **Alternate images**

    *Format:* `(media query preset): (filename) (...)`

    *Example:* `tablet: img_cropped.jpg mobile: img_cropped_more.jpg`

  Optionally specify any number of alternate base images for given [screen
  sizes]({{ site.baseurl }}/presets/#media-presets) (specified in `_data/picture.yml`). This is called [art
  direction](http://usecases.responsiveimages.org/#art-direction), and is one of JPT's strongest
  features.

  Give your images in order of ascending specificity (The first image is the most general). They will
  be provided to the browser in reverse order, and it will select the first one with an applicable
  media query.

* **Attributes**

  Optionally specify any number of HTML attributes, or an href target. These will be added to any
  attributes you've set in a preset.

  * **`--link`**

    *Format:* `--link (some url)`

    *Examples*: `--link https://example.com`, `--link /blog/some_post/`

      Wrap the image in an anchor tag, with the `href` attribute set to whatever value you give it.
      This will override automatic source image linking, if you have enabled it.

      **Note**: If you get either mangled HTML or extra {::nomarkdown} tags when using this, read
      [here]({{ site.baseurl }}/notes).

  * **`--alt`**
  
    *Format:* `--alt (alt text)`

    *Example:* `--alt Here is my alt text!`

    Convenience shortcut for `--img alt="..."`
  
  * **`--(element)`**

    *Format:* `--(picture|img|source|a|parent) (Standard HTML attributes)`

    *Example:* `--img class="awesome-fade-in" id="coolio" --a data-awesomeness="11"`

    Apply attributes to a given HTML element. Your options are:

    * `picture`
    * `img`
    * `source`
    * `a` (anchor tag)
    * `parent`

    `--parent` will be applied to the `<picture>` if present, otherwise the `<img>`; useful when
    using an `auto` output format.
