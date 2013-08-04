# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

Jekyll Picture Tag is a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com) static site. It follows the proposed [picture element](http://picture.responsiveimages.org/) pattern, and polyfills current browsers with [Picturefill](https://github.com/scottjehl/picturefill). Jekyll Picture Tag automatically creates resized source images, is fully configurable, and covers all use cases — including art direction and resolution switching — with a little YAML configuration and a simple template tag.

For non-responsive images in Jekyll, take a look at [Jekyll Img Tag](https://github.com/robwierzbowski/jekyll-img-tag).

## Why use Jekyll Picture Tag?

**Performance:** Static sites can be can be blazingly fast. If we're not using responsive images we're throwing those performance gains away by serving kilobytes of pixels a user will never see.

**Proof:** The picture element covers more responsive image use cases than any other proposed solution. As a result, the markup is more verbose. This plugin shows that in practice picture can be easy for website authors to use and maintain.

**Need more convincing?** Read [Tim Kadlec's](https://twitter.com/tkadlec) article [Why We Need Responsive Images](http://timkadlec.com/2013/06/why-we-need-responsive-images/). For an introduction to the picture element and responsive images in general see [Mo’ Pixels Mo’ Problems](http://alistapart.com/article/mo-pixels-mo-problems) and the follow up article [Ughck. Images](http://daverupert.com/2013/06/ughck-images/) by [Dave Rupert](https://twitter.com/davatron5000).

## Installation

Jekyll Picture Tag requires [Jekyll](http://jekyllrb.com) `>=1.0`, [Minimagick](https://github.com/minimagick/minimagick) `>=3.6`, and [Imagemagick](http://www.imagemagick.org/script/index.php). 

It also requires an HTML5 Markdown parser. If you're not using one already, install [Redcarpet](https://github.com/vmg/redcarpet) and add `markdown: redcarpet` to your _config.yml.

Once you have the requirements installed, copy picture_tag.rb into your Jekyll _plugins folder.

## Usage

There are three parts to Jekyll Picture Tag: 

- [Polyfill](#polyfill)
- [Liquid Tag](#liquid-tag)
- [Configuration](#configuration)

### Polyfill

The default `picturefill` markup requires Scott Jehl's [Picturefill](https://github.com/scottjehl/picturefill) polyfill. Download the library (and optionally matchMedia to support it) and add the scripts to your site.

### Liquid Tag

```
{% picture [preset] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute="value"] %}
```

The tag takes a mix of user input and pointers to configuration settings. 

#### picture

Tells Liquid this is a Jekyll Picture Tag.

#### preset

Optionally specify a picture [preset](#presets) to use, or leave blank for the `default` preset.

#### path/to/img.jpg

The base image that will be resized for your picture sources. Can be a jpeg, png, or gif.

#### source_key: path/to/alt/img.jpg

Optionally specify an alternate base image for a specific picture source. This is one of of picture's strongest features, often reffered to as the [art direction use case](http://usecases.responsiveimages.org/#art-direction). 

#### attribute="value"

Optionally specify any number of HTML attributes. These will be merged with any [attributes you've set in a preset](#attr). An attribute set in a tag will override the same attribute set in a preset.

You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

### Configuration

Jekyll Picture Tag stores settings in an `picture` key in your _config.yml. It takes a minute to set up your presets, but after that generating complex markup with a liquid tag is easy.

**Example settings**

```yml
picture:
  source: assets/images/_fullsize
  output: generated
  markup: "picturefill"
  presets:
    default:
      ...
    main:
      ...
    gallery:
      ...
```

**Example preset**

```yml
gallery:
  ppi: [1, 1.5]
  attr:
    class: "gallery-pict"
    itemprop: "image"
  source_medium:
    media: "(min-width: 40em)"
    width: "600"
    height: "300"
  source_default: 
    width: "300"
```

#### source

To make writing tags easier you can specify a source directory for your assets. Base images in the tag will be relative to the `source` directory. 

For example, if `source` is set to `assets/images/_fullsize`, the tag `{% picture enishte/portrait.jpg alt="An unsual picture" %}` will look for a file at `assets/images/_fullsize/enishte/portrait.jpg`.

Defaults to the site source directory.

#### output

Jekyll Picture Tag generates resized images to the `output` directory in your compiled site. The organization of your `source` directory is maintained in the output directory. 

Defaults to `{compiled Jekyll site}/generated`.

*__NOTE:__ `output` must be in a directory that contains other files or it will be erased. This is a [known bug](https://github.com/mojombo/jekyll/issues/1297) in Jekyll.*

#### markup

Choose `picturefill` to output markup for the Picturefill polyfill ([example](https://github.com/robwierzbowski/jekyll-picture-tag/blob/master/examples/output.html#L3-L13)) or `picture` to output markup for the proposed picture element ([example](https://github.com/robwierzbowski/jekyll-picture-tag/blob/master/examples/output.html#L17-L25)). When browsers implement picture just flip this setting and you're good to go.

Defaults to `picturefill`.

#### presets

Presets contain reusable settings for a Jekyll Picture Tag. Each is made up of a list of sources, and an optional attributes list and ppi array.

For example, a `gallery` preset might configure the picture sources for all responsive gallery images on your site, and set a class and some required metadata attributes. If the design changes, you can edit the `gallery` preset and the new settings will apply to every tag that references it.

The `default` preset will be used if no preset is specified in the liquid tag, and is required. A preset name can't contain the `.`, `:`, or `/` characters.

#### attr

Optionally add a list of html attributes to add to the main picturefill span or picture element when the preset is used.

Set the value of standalone attributes to `nil`. You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

An attribute set in a tag will override the same attribute set in a preset.

#### ppi

Optionally add an array of resolutions to automatically generate high ppi images and sources.

For example, the setting `[1, 1.5, 2]` will create sources that switch to 1.5x sized images on devices with a minimum resolution of 1.5dppx, and 2x images on devices with a minimum resolution of 2dppx. For finer grained control omit `ppi` and write resolution sources by hand.

#### sources

The picture tag uses multiple source elements with individual `src` and `media` attributes. The first source with a matching `media` attribute will be used. Each `source_*` becomes a source element in HTML.

All sources must be prefixed with `source_`. A `source_default` is required. Source names can't contain the `.`, `:`, or `/` characters.

Remember to arrange your sources from most restrictive `media` to the least restrictive. `source_default` does not accept a `media` key, and should always be last.

#### media

Specify a CSS media query in quotes. Each source except for `source_default` requires a `media` attribute. The first source with a matching media attribute will be displayed. You can use any CSS media query.

#### width and height

Set a pixel width and height to resize each source's image appropriately. A single value will scale proportionately; setting both will scale and crop.

## Using Liquid variables and JavaScript templating

You can use liquid variables in a picture tag:

```html
{% picture {{ post.featured_image }} alt="our project" %}
```

If you're using a JavaScript templating library such as Handlebars.js, the templating expression's opening braces must be escaped with backslashes like `\{\{` or `\{\%`. They'll be output as normal `{{ }}` expressions in HTML:

```
{% picture {{ post.featured_image }} alt="\{\{ user_name }}" %}.
```

## Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a smart caching system to speed up site compilation, and re-uses images as much as possible.

Try to use a base image that is larger than the largest resized image you need. Jekyll Picture Tag will warn you if a base image is too small, and won't upscale images.

By specifying a `source` directory that is ignored by Jekyll you can prevent huge base images from being copied to the compiled site. For example, `source: assets/images/_fullsize` and `output: generated` will result in a compiled site that contains resized images but not the originals.

The `output` directory is never deleted by Jekyll. You may want to manually clean it every once in a while to remove unused images.

Responsive images are a good first step to improve performance, but you should still use a build process to optimize site assets before deploying. If you're a cool kid, take a look at [Yeoman](http://yeoman.io/) and [generator-jekyllrb](https://github.com/robwierzbowski/generator-jekyllrb).

## Contribute

Report bugs and feature proposals in the [Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues). In lieu of a formal styleguide, take care to maintain the existing coding style. 

## Release History

0.2.2, Aug 2, 2013: Bugfixes.  
0.2.1, July 17, 2013: Refactor again, add Liquid parsing.  
0.2.0, July 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.  
0.1.1, July 5, 2013: Quick round of code improvements.  
0.1.0, July 5, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)