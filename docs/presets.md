# Writing Presets

Presets are stored in `_data/picture.yml`, to avoid cluttering `_config.yml`. You will have to
create this file, and probably the `_data/` directory as well.

All settings are optional, moderately sensible defaults have been implemented.

## Required Knowledge

If you don't understand responsive images, you won't know what to do with these settings. Jekyll
Picture tag is basically a programmatic implementation of the [MDN Responsive Images
guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).

If you don't know the difference between resolution switching and art direction, stop now and read it
in detail. Ideally, play around with a basic HTML file, a few test images, and a few different
browser widths until you understand it.

## Example settings

```yml

# _data/picture.yml

media_presets:
  wide_desktop: 'min-width: 1801px'
  desktop: 'max-width: 1800px'
  wide_tablet: 'max-width: 1200px'
  tablet: 'max-width: 900px'
  mobile: 'max-width: 600px'

markup_presets:
  default:
    formats: [webp, original]
    widths: [200, 400, 800, 1600]
    media_widths:
      mobile: [200, 400, 600]
      tablet: [400, 600, 800]
    size: 800px
    sizes:
      mobile: 100vw
      desktop: 60vw
    attributes:
      picture: 'class="awesome" data-volume="11"'
      img: 'class="some-other-class"'

  icon:
    base-width: 20
    pixel_ratios: [1, 1.5, 2]

  lazy:
    markup: data_auto
    formats: [webp, original]
    widths: [200, 400, 600, 800]
    noscript: true
    attributes:
      img: class="lazy"

```

## Media Presets

*Format:*

```yml
media_presets:
  (name): (css media query)
  (name): (css media query)
  (name): (css media query)
  (...)

```

*Example:*

```yml
media_presets:
  desktop: 'min-width: 1200px'
```

These are named media queries for use in a few different places.

Keys are names by which you can refer to the media queries supplied as their respective values.
These are used for specifying alternate source images in your liquid tag, and for building the
'sizes' attribute within your presets. Quotes are required around the media
queries, because yml gets confused by free colons.

## Markup Presets

*Format:*

```yml
markup_presets:
  (name):
    (option): (setting)
    (option): (setting)
    (option): (setting)
    (...)
  (another name):
    (option): (setting)
    (option): (setting)
    (option): (setting)
    (...)
```

*Example:*

```yml
markup_presets:
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

These are the 'presets' from previous versions, with different structure. Each entry is a
pre-defined collection of settings to build a given chunk of HTML and its respective images. You
can select one as the first argument given to the tag:

`{% picture my-preset image.jpg %}`

The `default` preset will be used if none is specified. A preset name can't contain the `.`, `:`,
or `/` characters.

#### A Note on srcsets, for the bad kids who didn't do the required reading.

There are 2 srcset formats, one based on providing widths, the other based on providing multipliers.

Width based srcsets look like this: `srcset="img.jpg 600w, img2.jpg 800w, img3.jpg 1000w"`. The
`(number)w` tells the browser how wide that image file is. Browsers are smart, they know their
device's pixel ratio, so in combination with the sizes attribute (if given, otherwise it assumes the
image will be 100vw) they can select the best-fitting image for the space it will fill on the screen. This is generally the one you want to use.

Multiplier based srcsets look like this: `srcset="img.jpg 1x, img2.jpg 1.5x, img3.jpg 3x"`. The
browser is less smart here; it looks at its own device's pixel ratio, compares it to the given
multiplier, and picks the closest one. It doesn't consider anything else at all. Multiplier based
srcsets are best used when the image will always be the same size, on all screen sizes.

To use a width based srcset in a preset, specify a `widths` setting (or don't, for the default), and
optionally the `sizes` and `size` settings.

To use a multiplier based srcset, set `pixel_ratios` and `base_width`.

### Markup preset settings

* **Markup format**

  *Format:* `markup: (setting)`

  *Default*: `auto`

  Defines what format the generated HTML will take. Here are your options:

  * `picture`: `<picture>` element surrounding a `<source>` tag for each required srcset, and a
    fallback `<img>`.
  * `img`: output a single `<img>` tag with a `srcset` entry.
  * `auto`: Supply an img tag when you have only one srcset, otherwise supply a picture tag.
  * `data_picture`, `data_img`, `data_auto`: Analogous to their counterparts,
    but instead of `src`, `srcset`, and `sizes`, you get `data-src`, `data-srcset`, and
    `data-sizes`. This allows you to use javascript for things like [lazy loading](https://github.com/verlok/lazyload)
  * `direct_url`: Generates an image and returns only its url. Uses `fallback_` properties (width
    and format)
  * `naked_srcset`: Builds a srcset and nothing else (not even the surrounding quotes). Useful with
    libraries requiring more complex or customized markup. Note that the (image) `format` setting
    must still be an array, even if you can only give it one value.
 
* **Image Formats**

  *Format:* `format: [format1, format2, (...)]`  

  *Example:* `format: [webp, original]`

  *Default*: `original`

  *Supported formats are anything which imagemagick supports, including the
  following:*
  * jpg/jpeg
  * png
  * gif
  * webp
  * jxr
  * jp2

  Array (yml sequence) of the image formats you'd like to generate, in decreasing order
  of preference. Browsers will render the first format they find and understand, so **If you put jpg
  before webp, your webp images will never be used**. `original` does what you'd expect. To supply
  webp, you must have an imagemagick webp delegate installed.

* **widths**

  *Format:* `widths: [integer, integer, (...)]`

  *Example:* `widths: [600, 800, 1200]`

  *Default*: `[400, 600, 800, 1000]`

  Array of image widths to generate, in pixels. For use when you want a size-based srcset
  (`srcset="img.jpg 800w, img2.jpg 1600w"`).

* **media_widths**

    *Format:*

    ```yml
    media_widths:
      (media preset name): [integer, integer, (...)]
    ```

    *Example:*

    ```yml
    media_widths:
      mobile: [400, 600, 800]
    ```

    *Default:* Widths setting

  If you are using art direction, there is no sense in generating desktop-size files for your mobile
  image. You can specify sets of widths to associate with given media queries. If not specified,
  will use `widths` setting.

* **Fallback Width**

    *Format:* `fallback_width: (integer)`             

    *Example:* `fallback_width: 800`

    *Default*: `800`

  Width of the fallback image.

* **Fallback Image**

    *Format:*  `fallback_format: (format)`

    *Example:* `fallback_format: jpg`

    *Default*: `original`

  Format of the fallback image

* **Sizes**

    *Format:*
    ```yml
    sizes:
      (media preset): (CSS dimension)
      (media preset): (CSS dimension)
      (media preset): (CSS dimension)
      (...)
    ```

    *Example:*
    ```yml
    sizes:
      mobile: 80vw
      tablet: 60vw
      desktop: 900px
    ```

  Conditional sizes, used to construct the `sizes=` HTML attribute telling the browser how wide your
  image will be (on the screen) when a given media query is true. CSS dimensions can be given in
  `px`, `em`, or `vw`. To be used along with a width based srcset.

  Provide these in order of most restrictive to least restrictive. The browser will choose the 
  first one with an applicable media query.

  You don't have to provide a sizes attribute at all. If you don't, the browser will assume the
  image is 100% the width of the viewport.

  The same sizes attribute is used for every source tag in a given picture tag. This causes some
  redundant markup, specifying sizes for situations when an image will never be rendered, but it 
  keeps things a bit simpler.

* **Size**

  *Format:* `size: (CSS Dimension)`

  *Example:* `size: 80vw`

  Unconditional image width to give the browser (by way of the html sizes attribute), to be supplied
  either alone or after all conditional sizes.

* **Pixel Ratios**

  *Format:* `pixel_ratios: [number, number, number (...)]`

  *Example:* `pixel_ratios: [1, 1.5, 2]`

  Array of images to construct, given in multiples of the base width. If you set this, you must also
  give a `base_width`.

  Set this when you want a multiplier based srcset (example: `srcset="img.jpg 1x, img2.jpg 2x"`).

* **Base Width**

  *Format:* `base_width: integer`

  *Example:* `base_width: 100`

  When using pixel ratios, you must supply a base width. This sets how wide the 1x image should be.

* **HTML Attributes**

  *Format:*

  ```yml
  attributes:
    (element): '(attributes)'
    (element): '(attributes)'
    (element): '(attributes)'
    (...)
  ```

  *Example:*

  ```yml
  attributes:
    img: 'class="soopercool" data-awesomeness="11"'
    picture: 'class="even-cooler"'
  ```

  HTML attributes you would like to add.  The same arguments are available here as in the liquid
  tag; element names, `alt:`, `url:`, and `parent:`. Unescaped double quotes cause problems with
  yml, so it's recommended to surround them with single quotes.

* **Noscript**

    *Format:* `noscript: (true|false)`

    *Example:* `noscript: true`

    *Default:* `false`

  For use with the `data_` output formats. When true, will include a basic `img` fallback within a
  `<noscript>` tag after the standard html. This allows you to use lazy loading or other javascript
  image tools, without breaking all of your images for non-javascript-enabled users.

* **Source Image Linking**

    *Format:* `link_source: (true|false)`

    *Example:* `link_source: true`

    *Default:* `false`

  Surround image with a link to the original source file. Your source image directory must
  be published as part of the compiled site.

* **Nomarkdown override**
   
    *Format:* `nomarkdown: (true|false)`

    *Example:* `nomarkdown: false`

    *Default:* `nil`

  Hard setting for `{::nomarkdown}` tags, overrides both autodetection and the global setting in
  `_config.yml`. See [notes](notes.md) for a detailed explanation. 

