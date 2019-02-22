# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

It's easy to throw an image on a webpage and call it a day. Doing justice to your users by serving it
efficiently on all screen sizes is tedious and tricky. Tedious, tricky things should be automated.

Jekyll Picture Tag is a liquid tag that adds responsive images to your
[Jekyll](http://jekyllrb.com) static site. It automatically creates resized,
reformatted source images, is fully configurable, implements sensible defaults,
and solves both the art direction and resolution switching problems, with a
little YAML configuration and a simple template tag. It can be configured to
work with JavaScript libraries such as 
[LazyLoad](https://github.com/verlok/lazyload).

## Why use Jekyll Picture Tag?

**Performance:** The fastest sites are static sites. If we're not using responsive images we're
throwing those performance gains away by serving kilobytes of pixels a user will never see.

**Design:** Your desktop image may not work well on mobile, regardless of its resolution. We often
want to do more than just resize images for different screen sizes.

**Developer Sanity:** Image downloading starts before the browser has parsed your CSS and
JavaScript; this gets them on the page *fast*, but it leads to some ridiculously verbose markup.
Ultimately, to serve responsive images correctly, we must: 

-   Generate, name, and organize the required images (formats \* resolutions, for each source image)
-   Inform the browser about the image itself-- format, size, URI, and the screen sizes where it
    should be used.
-   Inform the browser how large the space for that image on the page will be (which also probably has associated media
    queries).

It's a lot. It's tedious and complicated. Jekyll Picture Tag automates it.

## Features

* Automatic generation of resized, converted image files.
* Automatic generation of complex markup in one of several different formats.
* No configuration required, extensive configuration available.
* Auto-select between `<picture>` or lone `<img>` as necessary.
* Support for both width based and pixel ratio based srcsets.
* Webp conversion.
* `sizes` attribute assistance.
* named media queries so you don't have to remember them.
* Optional `<noscript>` tag with a basic fallback image, so you can lazy load without excluding your
    javascript-impaired users.
* Optionally, automatically link to the source image. Or manually link to anywhere else, with just a
    tag parameter!

# Required Knowledge

Jekyll Picture tag is basically a programmatic implementation of the [MDN Responsive Images
guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).
If you don't know the difference between resolution switching and art direction, stop now and read it
in detail. Ideally, play around with a basic HTML file, a few test images, and a few different
browser widths until you understand it.

# Table of Contents

* [Installation](#installation)
* [Usage](#usage)
* [Configuration](#configuration)
    * [Global](#global-configuration)
    * [Presets](#preset-configuration)
* [Other notes](#miscellaneous-tidbits)
* [Contribute](#contribute)
* [Release History](#release-history)
* [License](#license)

# Quick start / Demo

**All configuration is optional.** Here's the simplest possible use case:

Add j-p-t to your gemfile:

```ruby
group :jekyll_plugins do 
  gem 'jekyll-picture-tag', git: 'https://github.com/robwierzbowski/jekyll-picture-tag/'
end 
```

Write this:

`{% picture test.jpg %}`

Get this:

```html
<!-- Line breaks added for readability, the actual markup will not have them. -->
<img 
  src="http://localhost:4000/generated/test-800by450-195f7d.jpg" 
  srcset="
    http://localhost:4000/generated/test-400by225-195f7d.jpg 400w,
    http://localhost:4000/generated/test-600by338-195f7d.jpg 600w,
    http://localhost:4000/generated/test-800by450-195f7d.jpg 800w,
    http://localhost:4000/generated/test-1000by563-195f7d.jpg 1000w"
>
```

**Here's a more complete example:**

With this configuration:

```yml

# _data/picture.yml

media_presets:
  mobile: 'max-width: 600px'

markup_presets:
  default:
    widths: [600, 900, 1200]
    formats: [webp, original]
    sizes: 
      mobile: 80vw
    size: 500px

```

Write this:

`{% picture test.jpg mobile: test2.jpg --alt Alternate Text %}`

Get this:

```html

<!-- Formatted for readability -->
<picture>
  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    media="(max-width: 600px)"
    type="image/webp"
    srcset="http://localhost:4000/generated/test2-600by338-21bb6f.webp 600w,
    http://localhost:4000/generated/test2-900by506-21bb6f.webp 900w,
    http://localhost:4000/generated/test2-1200by675-21bb6f.webp 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    type="image/webp"
    srcset="http://localhost:4000/generated/test-600by338-195f7d.webp 600w,
    http://localhost:4000/generated/test-900by506-195f7d.webp 900w,
    http://localhost:4000/generated/test-1200by675-195f7d.webp 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    media="(max-width: 600px)"
    type="image/jpeg"
    srcset="http://localhost:4000/generated/test2-600by338-21bb6f.jpg 600w,
    http://localhost:4000/generated/test2-900by506-21bb6f.jpg 900w,
    http://localhost:4000/generated/test2-1200by675-21bb6f.jpg 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    type="image/jpeg"
    srcset="http://localhost:4000/generated/test-600by338-195f7d.jpg 600w,
    http://localhost:4000/generated/test-900by506-195f7d.jpg 900w,
    http://localhost:4000/generated/test-1200by675-195f7d.jpg 1200w">

  <img 
    src="http://localhost:4000/generated/test-800by450-195f7d.jpg"
    alt="Alternate Text">
</picture>
```

# Installation

Add `jekyll-picture-tag` to your Gemfile in the `:jekyll_plugins` group.
For now I don't have push access to RubyGems, meaning you have to point your gemfile at this git repo. 
If you don't you'll get an old, incompatible version.

```ruby
group :jekyll_plugins do 
  gem 'jekyll-picture-tag', git: 'https://github.com/robwierzbowski/jekyll-picture-tag/'
end 
```

### ImageMagick

Jekyll Picture Tag ultimately relies on [ImageMagick](https://www.imagemagick.org/script/index.php)
for image conversions, so it must be installed on your system. There's a very good chance you
already have it. If you want to build webp images, you will need to install a webp delegate for it
as well.

Verify it's installed by entering the following into a terminal:

    $ convert --version

You should see something like this:

    chronos@localhost ~ $ convert --version
    Version: ImageMagick 7.0.8-14 Q16 x86_64 2018-10-31 https://imagemagick.org
    Copyright: © 1999-2018 ImageMagick Studio LLC
    License: https://imagemagick.org/script/license.php
    Features: Cipher DPC HDRI OpenMP 
    Delegates (built-in): bzlib fontconfig freetype jng jp2 jpeg lcms lzma pangocairo png tiff webp xml zlib

Note webp under delegates. This is required if you want to generate webp files.

If you get a 'command not found' error, you'll need to install it. Most Linux package managers
include it, otherwise it can be downloaded [here](https://imagemagick.org/script/download.php)

# Usage

The tag takes a mix of user input and pointers to configuration settings:

`{% picture [preset] (source image) [alternate images] [attributes] %}`

Note the tag parser separates arguments by looking for some whitespace followed by `'--'`. If you
need to set HTML attribute values which begin with `'--'`, either set them first
(`class="--my-class"`) or using `_data/picture.yml` settings. `class="some-class
--some-other-class"` will break things.  

* **Preset**

  *Format:* `(name of a markup preset described in _data/picture.yml)`

  *Default:* `default`

  Optionally specify a markup [preset](#markup-presets) to use, or leave blank for the `default` preset.

* **Source Image** (Required)

  *Format:* `(Image filename, relative to source setting in _config.yml)`

  The base image that will be resized for your picture sources. Can be a jpeg, png, webp, or gif.

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

  ##### `--(element)` 

  *Format:* `--(picture|img|source|a|parent|alt) (Whatever HTML attributes you want)`

  *Example:* `--img class="awesome-fade-in" id="coolio" --a data-awesomeness="11"`

  Apply attributes to a given HTML element. Your options are:

  * `picture`
  * `img`
  * `source`
  * `a` (anchor tag)
  * `parent`
  * `alt`

  `--parent` will be applied to the `<picture>` if present, otherwise the `<img>`; useful when using
    the `auto` output format.

  `--alt` is a shortcut for `--img alt="..."`
    *Example:* `--alt Here is my alt text!`

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

`html {% picture {{ post.featured_image }} --alt Our Project %}`

# Configuration

**All configuration is optional**. If you are happy with the defaults, you don't have to touch a
single yaml file. 

## Global Configuration

Global settings are stored under the `picture:` key in `/_config.yml`.

**Example config:**

```yml
picture: 
  source: "assets/images/fullsize"
  output: "assets/images/generated"
```

* **Source Image Directory**

  *Format:* `source: (directory)`

  *Example:* `source: images/`

  *Default:* Jekyll site root.

  To make writing tags easier you can specify a source directory for your assets. Base images in the
  tag will be relative to the `source` directory, which is relative to the Jekyll site root. 

  For example, if `source` is set to `assets/images/_fullsize`, the tag 
  `{% picture enishte/portrait.jpg --alt An unsual picture %}` will look for a file at
  `assets/images/_fullsize/enishte/portrait.jpg`.

* **Destination Image Directory**

    *Format:* `output: (directory)`

    *Example:* `output: resized_images/`

    *Default*: `generated/` 

  Jekyll Picture Tag saves resized, reformatted images to the `output` directory in your compiled
  site. The organization of your `source` directory is maintained. 

  This setting is relative to your compiled site, which means `_site` unless you've changed it.

* **Suppress Warnings**

    *Format:* `suppress_warnings: (true|false)`

    *Example:* `suppress_warnings: true`

    *Default*: `false`

  Jekyll Picture Tag will warn you in a few different scenarios, such as when your base image is
  smaller than one of the sizes in your preset. (Note that Jekyll Picture Tag will never resize an
  image to be larger than its source). Set this value to `true`, and these warnings will not be shown.

* **Use Relative Urls**

    *Format:* `relative_url: (true|false)`

    *Example:* `relative_url: false`

    *Default*: `true`

  Whether to use relative (`/generated/test(...).jpg`) or absolute
  (`https://example.com/generated/test(...).jpg`) urls in your src and srcset attributes.

* **Kramdown nomarkdown fix**

  *Format:* `nomarkdown: (true|false)`

  *Example:* `nomarkdown: false`

  *Default*: `true`

  Whether or not to surround j-p-t's output with a `{::nomarkdown}..{:/nomarkdown}` block when called
  from within a markdown file. This one requires some explanation, but you can probably just leave
  it enabled.

  Under certain circumstances, Kramdown (Jekyll's default markdown parser) will get confused by HTML
  and will subsequently butcher it. One instance is when you wrap a block level element (such as a
  `<picture>`) within a span level element (such as an anchor tag). This flag fixes that issue.

  You should disable this if one of the following applies:
    * You have changed the markdown parser to something other than kramdown.
    * You will never wrap your images with links within a markdown file, and it's important that
      your generated markup is pretty.
    * It's causing issues. If you're seeing stray `{::nomarkdown}` or garbled HTML, try disabling
      this and in either case please file a bug report!

  Kramdown is finicky about when it will or won't listen to the `nomarkdown` option, depending on the
  line breaks before, after, and within the block. The most general solution I've found is to remove
  all line breaks from j-p-t's output, giving the whole shebang on one line. It makes for ugly markup,
  but it's pretty much only ever seen by the browser anyway. If you know a better way to accomplish
  this, I'm all ears!

## Preset Configuration

Presets are stored in `_data/picture.yml`, to avoid cluttering `_config.yml`. You will have to
create this file, and probably the `_data/` directory as well.

All settings are optional, moderately sensible defaults have been implemented. A template can be
found in the [example data file](examples/_data/picture.yml) in the examples directory.

**Example settings:** 

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

#### Media Presets

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

#### Markup Presets

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
image will be 100vw) they can select the best-fitting image for the space it will fill on the screen.

Multiplier based srcsets look like this: `srcset="img.jpg 1x, img2.jpg 1.5x, img3.jpg 3x"`. The 
browser is less smart here; it looks at its own device's pixel ratio, compares it to the given
multiplier, and picks the closest one. It doesn't consider anything else at all. Multiplier based
srcsets are best used when the image will always be the same size, on all screen sizes.

To use a width based srcset in a preset, specify a `widths` setting (or don't, for the default), and
optionally the `sizes` and `size` settings. 

To use a multiplier based srcset, set `pixel_ratios` and `base_width`. 

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

* **Image Formats**

  *Format:* `format: [format1, format2, (...)]`  

  *Example:* `format: [webp, original]`

  *Default*: `original`

  *Supported Formats:*
  * jpg/jpeg
  * png
  * gif
  * webp

  Array (yml sequence) of the image formats you'd like to generate, in decreasing order
  of preference. Browsers will render the first format they find and understand, so if you put jpg
  before webp, your webp images will never be used. `original` does what you'd expect. To supply
  webp, you must have an imagemagick webp delegate installed, described [here](#imagemagick).

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

* **Fallback Image**

    *Format:* `fallback_width: (integer)`
              `fallback_format: (format)`

    *Example:* `fallback_width: 800`
               `fallback_format: jpg`

    *Default*: `800` and `original` 

  Properties of the fallback image, format and width. 

* **Sizes**

    *Format:* 
    ```yml
    sizes:
      (media query): (CSS dimension)
      (media query): (CSS dimension)
      (media query): (CSS dimension)
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

  You don't have to provide a sizes attribute at all. If you don't, the browser will assume the
  image is 100% the width of the viewport.

  The same sizes attribute is used for every source tag in a given picture tag. This causes some
  redundant markup, specifying sizes for situations when an image will never be rendered, but it
  simplifies configuration greatly.

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
  be published as part of the compiled site. The same caveats apply as the `--url` flag: don't
  disable `nomarkdown` if you'll be using this from within a kramdown parsed markdown file.

# Miscellaneous Tidbits

### Lazy Loading, and other javascript related tomfoolery

Use one of the `data_` output formats and something like
[LazyLoad](https://github.com/verlok/lazyload). The 'lazy' preset in the example config will work.

### PictureFill

[Picturefill](http://scottjehl.github.io/picturefill/) version 3 no longer requires special markup.
Standard outputs should be compatible.

### Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a smart
caching system to speed up site compilation, and re-uses images as much as possible. Filenames
take the following format:

`(original filename without extension)_(width)by(height)_(source hash).(format)`

Source hash is the first 5 characters of an md5 checksum of the source image.

Try to use a base image that is larger than the largest resized image you need. Jekyll Picture Tag
will warn you if a base image is too small, and won't upscale images.

By specifying a `source` directory that is ignored by Jekyll you can prevent huge base images from
being copied to the compiled site. For example, `source: assets/images/_fullsize` and `output:
generated` will result in a compiled site that contains resized images but not the originals. Note
that this will break source image linking, if you wish to enable it. (Can't link to images that
aren't public!)

The `output` directory is never deleted by Jekyll. You may want to manually clean it every once in a
while to remove unused images.

# Contribute

Report bugs and feature proposals in the 
[Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues).

Pull requests are encouraged. With a few exceptions, this plugin is written to follow the Rubocop
default settings (except the frozen string literal comment).

If you add a new setting, it is helpful to add a default value (look under `lib/defaults/`) and
relevant documentation to the readme. Don't let that stop you from submitting a pull request,
though! Just allow modifications and I'll take care of it.

# Release History

* 1.2.0 Feb  9, 2019: Add nomarkdown fix, noscript option, relative url option, anchor tag wrappers
* 1.1.0 Jan 22, 2019: Add direct_url markup format, auto-orient images before stripping metadata.
* 1.0.2 Jan 18, 2019: Fix ruby version specification
* 1.0.1 Jan 13, 2019: Added ruby version checking for more helpful error messages when running old versions of ruby.
* **1.0.0** Nov 27, 2018: Rewrite from the ground up. See [migration.md](/migration.md).
* 0.2.2 Aug  2, 2013: Bugfixes. 
* 0.2.1 Jul 17, 2013: Refactor again, add Liquid parsing.
* 0.2.0 Jul 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.
* 0.1.1 Jul  5, 2013: Quick round of code improvements.
* 0.1.0 Jul  5, 2013: Initial release.

# License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)
