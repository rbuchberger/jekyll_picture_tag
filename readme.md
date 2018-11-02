# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

Jekyll Picture Tag is a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com)
static site. It follows either the [picture element](http://picture.responsiveimages.org/) pattern,
or it can create an img tag with a srcset. Jekyll Picture Tag automatically creates resized,
reformatted source images, is fully configurable, and covers all use cases — including art direction
and resolution switching — with a little YAML configuration and a simple template tag.

## Why use Jekyll Picture Tag?

**Performance:** Static sites can be can be blazingly fast. If we're not using responsive images
we're throwing those performance gains away by serving kilobytes of pixels a user will never see.

**Proof:** The picture element covers more responsive image use cases than any other proposed
solution. As a result, the markup is more verbose. This plugin shows that in practice picture can be
easy for website authors to use and maintain.

**Need more convincing?** Read [Tim Kadlec's](https://twitter.com/tkadlec) article [Why We Need
Responsive Images](http://timkadlec.com/2013/06/why-we-need-responsive-images/). For an introduction
to the picture element and responsive images in general see [Mo’ Pixels Mo’
Problems](http://alistapart.com/article/mo-pixels-mo-problems) and the follow up article [Ughck.
Images](http://daverupert.com/2013/06/ughck-images/) by [Dave
Rupert](https://twitter.com/davatron5000).

## Installation

Add `jekyll-picture-tag` to your Gemfile in the `:jekyll_plugins` group. For example:

```ruby 
group :jekyll_plugins do 
gem 'jekyll-picture-tag', '~> 0.2.3'
end 
```

Add `jekyll-picture-tag` to your `_config.yml` under `plugins:`
```
plugins:
  - jekyll-picture-tag

```

Jekyll Picture Tag ultimately relies on [ImageMagick](https://www.imagemagick.org/script/index.php)
for image conversions, so it must be installed on your system. If you want to build webp images, you
will need to install a webp delegate for ImageMagick as well.

Here's how you can check if it's already installed (good chance it is):
```

imagemagick --version

```

Here's the install process on ubuntu:

```
sudo apt install imagemagick
sudo apt install webp

```

Chromebook with chromebrew:

```
crew install imagemagick

```

(I'd love help adding install instructions for other OSes. If you come across a guide that works
well, please either submit an issue telling me about it, or add it to these instructions with a pull
request!)

It also requires an HTML5 Markdown parser. If you're not using one already, install
[Redcarpet](https://github.com/vmg/redcarpet) and add `markdown: redcarpet` to your _config.yml.


## Usage

### Liquid Tag

``` {% picture [preset] img.jpg [media_query_preset: alt.jpg] [attributes] %} ```

The tag takes a mix of user input and pointers to configuration settings. 

#### picture

Tells Liquid this is a Jekyll Picture Tag.

#### preset

Optionally specify a picture [preset](#presets) to use, or leave blank for the `default` preset.

#### img.jpg

The base image that will be resized for your picture sources. Can be a jpeg, png, webp, or gif.

#### media_query_preset: alt.jpg

Optionally specify alternate base images for given media queries (specified in _data/picture.yml).
This is one of of picture's strongest features, often reffered to as the [art direction use
case](http://usecases.responsiveimages.org/#art-direction). 

#### attributes

Optionally specify any number of HTML attributes. These will be merged with any [attributes you've
set in a preset](#attr). An attribute set in a tag will override the same attribute set in a preset.

You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

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

Defaults to the site source directory.

#### output

Jekyll Picture Tag generates resized images to the `output` directory in your compiled site. The
organization of your `source` directory is maintained in the output directory. 

Defaults to `{compiled Jekyll site}/generated`.

*__NOTE:__ `output` must be in a directory that contains other files or it will be erased. This is a
[known bug](https://github.com/mojombo/jekyll/issues/1297) in Jekyll.*

**Example _data/picture.yml**

All settings are optional, moderately sensible defaults have been implemented. For an explanation of
settings, look at the example data file in the examples directory.

```

media_presets:
  wide_desktop: min-width: 1801px;
  desktop: max-width: 1800px;
  wide_tablet: max-width: 1200px;
  tablet: max-width: 900px;
  mobile: max-width: 600px;

markup-presets:
  default:
    markup: auto
    formats: [webp, original]
    width: [200, 400, 800, 1600]
    widths: 
      mobile: [200, 400, 600] 
      tablet: [400, 600, 800]
    size: 800px
    sizes: 
      mobile: 100vw
      desktop: 60vw
    fallback:
      width: 800
      format: original
    attributes:
      picture: class="awesome" data-volume="11"
      img: class="some-other-class"

  icon:
    base-width: 20
    pixel_ratios: [1, 1.5, 2]
```

#### media_presets
  Keys are names by which you can refer to the media queries supplied as their respective values.
  These are used for specifying alternate source images in your liquid tag, and for building the
  'sizes' attribute within your presets.

#### markup-presets
  These are the 'presets' from previous versions, with different structure. Each entry is a
  pre-defined collection of settings to build a given chunk of HTML and its respective images.

  The `default` preset will be used if no preset is specified in the liquid tag, and is required. A
  preset name can't contain the `.`, `:`, or `/` characters.

#### markup

* `picture`: output markup based on the `<picture>` element. 
* `img`: output a single `img` tag with a `srcset` entry.
* `auto`: Supply an img tag when you have only one srcset, otherwise supply a picture tag.

#### formats
Array (yml sequence) of the image formats you'd like to generate, in decreasing order of preference.
`original` does what you'd expect. To supply webp, you must install an imagemagick webp delegate.

#### fallback
  Properties of the fallback image; format and width. Default values are 800px and original.

#### width
  For use when you want a specified size-based srcset (example: `srcset="img.jpg 800w, img2.jpg
  1600w"`). Array of image widths to generate, in pixels.

#### widths
  If you are using art direction, there is no sense in generating desktop-size files for your
  mobile image. You can specify sets of widths to associate with given media queries.

#### size
Unconditional image width to give the browser (by way of the html sizes attribute), to be supplied
either alone or after all conditional sizes.

#### sizes
Conditional sizes, telling the browser how wide your image will be when a given media query is true.

#### base-width
For use when you want a multiplier based srcset (example: `srcset="img.jpg 1x, img2.jpg 2x"`). This base-width sets how
wide the 1x image should be.
#### pixel_ratios
Array of images to construct, given in multiples of the base width.

#### attributes

Optionally add a list of html attributes to add to the main picturefill span or picture element when
the preset is used.

An attribute set in a tag will override the same attribute set in a preset.


## Using Liquid variables and JavaScript templating

You can use liquid variables in a picture tag:

```html {% picture {{ post.featured_image }} alt="our project" %} ```

## Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a smart
caching system to speed up site compilation, and re-uses images as much as possible.

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

Report bugs and feature proposals in the [Github issue
tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues). In lieu of a formal
styleguide, take care to maintain the existing coding style. 

## Release History

0.2.2, Aug 2, 2013: Bugfixes.  0.2.1, July 17, 2013: Refactor again, add Liquid parsing.  0.2.0,
July 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.  0.1.1, July 5, 2013: Quick
round of code improvements.  0.1.0, July 5, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)

[![Bitdeli
Badge](https://d2weczhvl823v0.cloudfront.net/robwierzbowski/jekyll-picture-tag/trend.png)](https://bitdeli.com/free
"Bitdeli Badge")
