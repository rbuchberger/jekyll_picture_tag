# Liquid Tag Usage

The tag takes a mix of user input and pointers to configuration settings:

`{% picture [preset] (source image) [alternate images] [attributes] %}`

Note the tag parser separates arguments by looking for some whitespace followed by `'--'`. If you
need to set HTML attribute values which begin with `'--'`, either set them first
(`class="--my-class"`) or using `_data/picture.yml` settings. `class="some-class
--some-other-class"` will break things.  

## Examples:

`{% picture example.jpg %}`

`{% picture thumbnail example.jpg %}`

`{% picture blog_index {{ post.image }} --link {{ post.url }} %}`

```
{% picture 
  hero 
  example.jpg 
  mobile: example_cropped.jpg 
  --alt Happy Puppy 
  --picture class="hero" 
  --link /
%}
```

## Argument reference

* **Preset**

  *Format:* `(name of a markup preset described in _data/picture.yml)`

  *Default:* `default`

  Optionally specify a markup [preset](https://github.com/rbuchberger/jekyll_picture_tag/wiki/Writing-Presets) to use, or leave blank for the `default` preset.

* **Source Image** (Required)

  *Format:* `(Image filename, relative to source setting in _config.yml)`

  The base image that will be resized for your picture sources. Can be pretty much any raster image (as long as imagemagick understands it).

* **Alternate images**

    *Format:* `(media query preset): (image filename, relative to source directory)`

    *Example:* `tablet: img_cropped.jpg mobile: img_cropped_more.jpg`

  Optionally specify any number of alternate base images for given [media queries](#media-presets)
  (specified in `_data/picture.yml`). This is one of of picture's strongest features, often referred
  to as the [art direction use case](http://usecases.responsiveimages.org/#art-direction).

  Give your images in order of ascending specificity (The first image is the most general). They will
  be provided to the browser in reverse order, and it will select the first one with a media query
  that evaluates true.

* **Attributes**

  Optionally specify any number of HTML attributes. These will be added to any attributes you've
  set in a preset. They can take a few different formats:

  ##### `--link`

  *Format:* `--link (some url)`

  *Examples*: `--link https://example.com`, `--link /blog/some_post/`

    Wrap the image in an anchor tag, with the `href` attribute set to whatever value you give it.
    This will override automatic source image linking, if you have enabled it.

    **Note**: Don't disable the `nomarkdown` global setting if you would like do this within markdown
    files and you are using Kramdown (Jekyll's default markdown parser.)
  ##### `--alt`
  
  *Format:* `--alt (alt text)`

  *Example:* `--alt Here is my alt text!`

  Shortcut for `--img alt="..."`
  
  ##### `--(element)`

  *Format:* `--(picture|img|source|a|parent) (Standard HTML attributes)`

  *Example:* `--img class="awesome-fade-in" id="coolio" --a data-awesomeness="11"`

  Apply attributes to a given HTML element. Your options are:

  * `picture`
  * `img`
  * `source`
  * `a` (anchor tag)
  * `parent`

  `--parent` will be applied to the `<picture>` if present, otherwise the `<img>`; useful when using
    the `auto` output format.

  ##### Old syntax

  The old syntax is to just dump all attributes at the end:

  `{% picture example.jpg alt="alt text" class="super-duper" %}`

  This will continue to work. For backwards compatibility, behavior of previous versions is
  maintained: all attributes specified this way are applied to the img tag.

#### Line breaks
Line breaks and spaces are interchangeable, the following is perfectly acceptable:

```
{%
  picture my-preset
    img.jpg
    mobile: alt.jpg
    --alt Alt Text
    --picture class="stumpy"
%}
```
#### Liquid variables

You can use liquid variables in a picture tag:

`{% picture {{ post.featured_image }} --alt Our Project %}`
