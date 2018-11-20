# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

Jekyll Picture Tag is a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com)
static site. It generates both `<picture>` and `<img>` tags, along with their accompanying attributes
and associated images. Jekyll Picture Tag automatically creates resized, reformatted source images,
is fully configurable, implements sensible defaults, and covers all use cases — including art
direction and resolution switching — with a little YAML configuration and a simple template tag.

## Why use Jekyll Picture Tag?

**Performance:** Static sites can be can be blazingly fast. If we're not using responsive images
we're throwing those performance gains away by serving kilobytes of pixels a user will never see.

Browsers start downloading images before they've parsed your CSS, or fired up your javascript. This
means that, at least for images above the fold, you can't do it with javascript without hurting
render time.

**Convenience:** Ultimately, to serve responsive images correctly, we must (and without css or
javascript): 
* Generate required images (formats * resolutions, for each source image)
* name those images
* tell the browser an associated resolution, format, and possibly media query for each image
* Inform the browser how large the space for that image on the page will be (which also probably has associated media
queries).

It's a lot. It's tedious and complicated. Jekyll Picture Tag automates it.

Write this:

`{% picture test.jpg test2.jpg --alt Alternate Text %}`

With a little configuration, get this (and a pile of images to go along):

```html

<picture class="my-configured-class">
  <source sizes="(max-width: 1200px) 80vw, 800px" media="(max-width: 600px)" type="image/webp" srcset="http://localhost:4000/generated/test2-200by113-21bb6f.webp 200w, http://localhost:4000/generated/test2-400by225-21bb6f.webp 400w, http://localhost:4000/generated/test2-600by338-21bb6f.webp 600w, http://localhost:4000/generated/test2-800by450-21bb6f.webp 800w, http://localhost:4000/generated/test2-1000by563-21bb6f.webp 1000w">
  <source sizes="(max-width: 1200px) 80vw, 800px" type="image/webp" srcset="http://localhost:4000/generated/test-200by113-195f7d.webp 200w, http://localhost:4000/generated/test-400by225-195f7d.webp 400w, http://localhost:4000/generated/test-600by338-195f7d.webp 600w, http://localhost:4000/generated/test-800by450-195f7d.webp 800w, http://localhost:4000/generated/test-1000by563-195f7d.webp 1000w">
  <source sizes="(max-width: 1200px) 80vw, 800px" media="(max-width: 600px)" type="image/jpeg" srcset="http://localhost:4000/generated/test2-200by113-21bb6f.jpg 200w, http://localhost:4000/generated/test2-400by225-21bb6f.jpg 400w, http://localhost:4000/generated/test2-600by338-21bb6f.jpg 600w, http://localhost:4000/generated/test2-800by450-21bb6f.jpg 800w, http://localhost:4000/generated/test2-1000by563-21bb6f.jpg 1000w">
  <source sizes="(max-width: 1200px) 80vw, 800px" type="image/jpeg" srcset="http://localhost:4000/generated/test-200by113-195f7d.jpg 200w, http://localhost:4000/generated/test-400by225-195f7d.jpg 400w, http://localhost:4000/generated/test-600by338-195f7d.jpg 600w, http://localhost:4000/generated/test-800by450-195f7d.jpg 800w, http://localhost:4000/generated/test-1000by563-195f7d.jpg 1000w">
  <img src="http://localhost:4000/generated/test-800by450-195f7d.jpg" alt="Alternate Text">
</picture>

```
## Strongly Recommended Reading

Jekyll Picture tag is basically a programmatic implementation of the 
[MDN Responsive Images guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).
You should be familiar with these concepts in order to understand how to configure and use it.

## Installation

Add `jekyll-picture-tag` to your Gemfile in the `:jekyll_plugins` group.

```ruby 
group :jekyll_plugins do 
  gem 'jekyll-picture-tag', '~> 1.0.0'
end 
```

Jekyll Picture Tag ultimately relies on [ImageMagick](https://www.imagemagick.org/script/index.php)
for image conversions, so it must be installed on your system. If you want to build webp images, you
will need to install a webp delegate for ImageMagick as well.

Verify that you have it by entering the following into a terminal:

```
convert --version

```
You should see something like this:

```
chronos@localhost ~ $ convert --version
Version: ImageMagick 7.0.8-14 Q16 x86_64 2018-10-31 https://imagemagick.org
Copyright: © 1999-2018 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI OpenMP 
Delegates (built-in): bzlib fontconfig freetype jng jp2 jpeg lcms lzma pangocairo png tiff webp xml zlib

```

Note webp under delegates. This is required if you want to generate webp files.


If you get a 'command not found' error, you'll need to install it.

#### Ubuntu installation:

```
sudo apt install imagemagick
(...)
sudo apt install webp
(...)

```

#### Chromebook installation via [chromebrew](https://github.com/skycocker/chromebrew)

```
crew install imagemagick

```

**Help with instructions for other OSes is greatly appreciated!**

## Usage

### Quick start

All configuration is optional. Image filenames are relative to the site root directory.

With no configuration, Write this:

`{% picture test.jpg %}`

Get this:

```html

<img 
  src="http://localhost:4000/generated/test-800by450-195f7d.jpg" 
  srcset="
    http://localhost:4000/generated/test-400by225-195f7d.jpg 400w,
    http://localhost:4000/generated/test-600by338-195f7d.jpg 600w,
    http://localhost:4000/generated/test-800by450-195f7d.jpg 800w,
    http://localhost:4000/generated/test-1000by563-195f7d.jpg 1000w"
>

```
(Line breaks added for readability. The actual rendered markup will not have them.)

Basically, an img tag, with a srcset consisting of images in the supplied format, resized to be 400,
600, 800, and 1000px wide, and a fallback src of 800px. Because there is no sizes attribute, the
browser will assume the image is 100% of the width of the viewport. 

It's not perfect, but it's a good start and far better than serving up desktop-size images to
mobile users.

### Normal Usage

``` {% picture [preset] img.jpg [media_query_preset: alt.jpg] [attributes] %} ```

The tag takes a mix of user input and pointers to configuration settings. 

#### picture

Tells Liquid this is a Jekyll Picture Tag.

#### preset

Optionally specify a markup [preset](#markup_presets) to use, or leave blank for the `default` preset.

#### img.jpg

The base image that will be resized for your picture sources. Can be a jpeg, png, webp, or gif.

#### media_query_preset: alt.jpg

Optionally specify alternate base images for given [media queries](media_presets) (specified in _data/picture.yml).
This is one of of picture's strongest features, often referred to as the [art direction use
case](http://usecases.responsiveimages.org/#art-direction). 

Give your images in order of ascending specificity (The first image is the most general). They will
be provided to the browser in reverse order, and it will select the first one with a media query
that evaluates true.

#### attributes

Optionally specify any number of HTML attributes. These will be merged with any attributes you've
set in a preset.

`--(element)` will apply those attributes to the given element. Your options are picture, img, or
source.

`--alt` is a shortcut for `--img alt="..."`

`--parent` will be applied to the outermost element; useful when using the
`auto` output format.

Example: 

`--picture class="killer" --alt Alternate Text --source data-volume="11" `

The old syntax is to just dump them at the end:

` alt="alt text" class="super-duper" `

This will continue to work. For backwards compatibility, behavior of previous versions is
maintained: all attributes specified this way are applied to the img tag. 

### Configuration

Jekyll Picture Tag stores global settings under the `picture` key in your _config.yml, and presets
under _data/picture.yml (to avoid cluttering your config.yml)

**Example settings under _config.yml**

```yml 
picture: 
  source: "assets/images/_fullsize"
  output: "generated" 
```
#### source

To make writing tags easier you can specify a source directory for your assets. Base images in the
tag will be relative to the `source` directory. 

For example, if `source` is set to `assets/images/_fullsize`, the tag 
`{% picture enishte/portrait.jpg alt="An unsual picture" %}` will look for a file at
`assets/images/_fullsize/enishte/portrait.jpg`.

Default: Jekyll source directory.

#### output

Jekyll Picture Tag generates resized images to the `output` directory in your compiled site. The
organization of your `source` directory is maintained in the output directory. 

Default: `{compiled Jekyll site}/generated`. `{compiled Jekyll site}` means `_site`, unless you've
changed it.

**Example _data/picture.yml**

All settings are optional, moderately sensible defaults have been implemented. A template can be
found in the 
[example data file](https://github.com/robwierzbowski/jekyll-picture-tag/blob/refactor/examples/_data/picture.yml)
in the examples directory.

```

media_presets:
  wide_desktop: 'min-width: 1801px'
  desktop: 'max-width: 1800px'
  wide_tablet: 'max-width: 1200px'
  tablet: 'max-width: 900px'
  mobile: 'max-width: 600px'

markup_presets:
  default:
    markup: auto
    formats: [webp, original]
    widths: [200, 400, 800, 1600]
    media_widths: 
      mobile: [200, 400, 600] 
      tablet: [400, 600, 800]
    size: 800px
    sizes: 
      mobile: 100vw
      desktop: 60vw
    fallback_width: 800
    fallback_format: original
    attributes:
      picture: 'class="awesome" data-volume="11"'
      img: 'class="some-other-class"'

  icon:
    base-width: 20
    pixel_ratios: [1, 1.5, 2]
```

#### media_presets
  Keys are names by which you can refer to the media queries supplied as their respective values.
  These are used for specifying alternate source images in your liquid tag, and for building the
  'sizes' attribute within your presets. Quotes are required around them, because yml gets confused
  by free colons.

#### markup_presets
  These are the 'presets' from previous versions, with different structure. Each entry is a
  pre-defined collection of settings to build a given chunk of HTML and its respective images.

  The `default` preset will be used if none is specified in the liquid tag. A preset name can't
  contain the `.`, `:`, or `/` characters.

#### markup

* `picture`: output markup based on the `<picture>` element. 
* `img`: output a single `img` tag with a `srcset` entry.
* `auto`: Supply an img tag when you have only one srcset, otherwise supply a picture tag.

Default: auto

#### formats 
Array (yml sequence) of the image formats you'd like to generate, in decreasing order
of preference.  Browsers will render the first format they find and understand, so if you put jpg
before webp, your webp images will never be used.  `original` does what you'd expect. To supply
webp, you must install an imagemagick webp delegate.

Default: original

#### fallback_width, fallback_format
Properties of the fallback image, format and width. 

Default: 800px and original.

#### widths
For use when you want a size-based srcset (example: `srcset="img.jpg 800w, img2.jpg
1600w"`). Array of image widths to generate, in pixels. 

Default: [400, 600, 800, 1000]

#### media_widths
If you are using art direction, there is no sense in generating desktop-size files for your
mobile image. You can specify sets of widths to associate with given media queries.

#### sizes
Conditional sizes; these will be used to construct the `sizes=` HTML attribute telling the browser
how wide your image will be when a given media query is true.

#### size
Unconditional image width to give the browser (by way of the html sizes attribute), to be supplied
either alone or after all conditional sizes.

#### base-width
For use when you want a multiplier based srcset (example: `srcset="img.jpg 1x, img2.jpg 2x"`). This base-width sets how
wide the 1x image should be.

#### pixel_ratios
Array of images to construct, given in multiples of the base width.

#### attributes

Additional HTML attributes you would like to add. An attribute set in a tag will override the same
attribute set in a preset.

The same arguments are available here as in the liquid tag; element names, `alt:`, and `parent:`.
They follow the format of (element name): 'attribute="value" attribute2="value2"'. (Unescaped double
quotes cause problems with yml, so surround the entire string with single quotes.)

## Liquid variables

You can use liquid variables in a picture tag:

```html {% picture {{ post.featured_image }} alt="our project" %} ```

## Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a smart
caching system to speed up site compilation, and re-uses images as much as possible. Filenames
take the following format:
`(original filename minus extension)_(width)by(height)_(source hash).(format)`
Source hash is the first 5 characters of the md5 checksum of the source image.

Try to use a base image that is larger than the largest resized image you need. Jekyll Picture Tag
will warn you if a base image is too small, and won't upscale images.

By specifying a `source` directory that is ignored by Jekyll you can prevent huge base images from
being copied to the compiled site. For example, `source: assets/images/_fullsize` and `output:
generated` will result in a compiled site that contains resized images but not the originals.

The `output` directory is never deleted by Jekyll. You may want to manually clean it every once in a
while to remove unused images.

Responsive images are a good first step to improve performance, but you should still use a build
process to optimize site assets before deploying. If you're a cool kid, take a look at
[Yeoman](http://yeoman.io/) and
[generator-jekyllrb](https://github.com/robwierzbowski/generator-jekyllrb).

## Contribute

Report bugs and feature proposals in the 
[Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues).

Pull requests are encouraged. With a few exceptions, this plugin is written to follow the Rubocop
default settings.

## Release History

0.2.2, Aug 2, 2013: Bugfixes.  0.2.1, July 17, 2013: Refactor again, add Liquid parsing.  0.2.0,
July 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.  0.1.1, July 5, 2013: Quick
round of code improvements.  0.1.0, July 5, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)

[![Bitdeli
Badge](https://d2weczhvl823v0.cloudfront.net/robwierzbowski/jekyll-picture-tag/trend.png)](https://bitdeli.com/free
"Bitdeli Badge")
