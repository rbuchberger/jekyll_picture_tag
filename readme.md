# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

Jekyll Picture Tag is a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com) static site. It follows the proposed [picture element](http://picture.responsiveimages.org/) pattern, and polyfills current browsers with [Picturefill](https://github.com/scottjehl/picturefill). Jekyll Picture Tag automatically creates resized source images, is fully configurable, and covers all use cases — including art direction and resolution switching — with a little YAML configuration and a simple template tag.

## Why use Jekyll Picture Tag?

**Performance:** Static sites can be can be blazingly fast. We shouldn't throw these performance gains away by serving kilobytes of pixels a user will never see. 

**Proof:** The picture element covers more responsive image use cases than any other proposed solution. As a result the markup is more verbose. This plugin shows that in practice picture can be easy for website authors to use and maintain.

**Need more convincing?** For an introduction to the picture element and responsive images in general see [Mo’ Pixels Mo’ Problems](http://alistapart.com/article/mo-pixels-mo-problems) and the follow up article [Ughck. Images](http://daverupert.com/2013/06/ughck-images/) by [Dave Rupert](https://twitter.com/davatron5000).

## Installation

Jekyll Picture Tag requires [Jekyll](http://jekyllrb.com) `>=1.0`, [Minimagick](https://github.com/minimagick/minimagick) `>=3.6`, and [Imagemagick](http://www.imagemagick.org/script/index.php).  
Once those are installed, copy picture_tag.rb into your Jekyll _plugins folder.

Jekyll Picture Tag outputs HTML5, and requires an HTML5 markdown parser. If it's not already set, add `markdown: redcarpet` or any other HTML5 markdown parser to your _config.yml.

## Usage

There are three parts to Jekyll Picture Tag: 

- [Polyfill](#polyfill)
- [Liquid Tag](#liquid-tag)
- [Configuration](#configuration)

### Polyfill

The default `picturefill` markup requires Scott Jehl's [Picturefill](https://github.com/scottjehl/picturefill). Download the library (and optionally matchMedia to support it) and add the scripts to your site. 

### Liquid Tag

```
{% picture [preset] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute="value"] %}
```

The tag takes a mix of user input and pointers to configuration settings. 

#### `picture`

Tells Liquid this is a Jekyll Picture Tag.

#### `preset`

Optionally specify a picture [preset](#presets) to use, or leave blank for the `default` preset.

#### `path/to/img.jpg` 

Choose a base image for the picture. This image will be resized for all of your responsive picture sources.

#### `source_key: path/to/alt/img.jpg`

Optionally specify an alternate base image for a specific picture source. This is one of of picture's strongest features, often reffered to as the [art direction use case](http://usecases.responsiveimages.org/#art-direction). 

#### `attribute="value"`

Optionally specify any number of HTML attributes. These will be merged with any [attributes you've set in the _config.yml](#attr). You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

### Configuration

Jekyll Picture Tag stores configuration in your site's _config.yml under the `picture` key. It takes a minute to set up your presets, but after that generating complex markup with a single liquid tag is easy.

**Example settings**

```yml
picture:
  source_path: "assets/images/_picture"
  output_path: "assets/images/picture"
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

#### `source_path`

To make it easier to write tags, you can specify a source directory for your assets. All base image paths will be relative to this directory. 

For example, if you set `source_path: assets/_picture`, the `{% picture posters/dr_jekyll.jpg %}` tag will look for a file at `assets/_picture/posters/dr_jekyll.jpg`.

Defaults to the Jekyll source directory.

#### `output_path`

Jekyll Picture Tag automatically generates resized source images when you build the site. These are output to the `output_path` in your compiled site directory. The organization of your source directory is maintained in the output directory.

Defaults to `{compiled_site}/{source_path}/generated`.

#### `markup`

Choose `picturefill` to output markup for the Picturefill polyfill ([example]()) or `picture` to output markup for the proposed picture element ([example]()). When browsers implement picture just flip this setting and you're good to go.

Defaults to `picturefill`.

#### `presets`

Presets are reusable picture styles that are referenced in the liquid tag. The `default` preset is required. A preset name can't contain the `.`, `:`, or `/` characters.

#### `attr`

Each preset can have an optional list of HTML attributes associated with it. These attributes will be automatically inserted when the preset is used. 

Setting an attribute in a tag will override the same attribute set in `attr`. Set the value of standalone attributes to `nil`. You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

#### `ppi`

The `ppi` array automatically generates hi-ppi versions of your sources and images with a cross browser media atrribute. The setting `[1, 1.5, 2]` will create sources that switch to 1.5x sized images on devices with a minimum resolution of 1.5dppx, and 2x images on devices with a minimum resolution of 2dppx. For finer grained control omit `ppi` and write resolution sources by hand.

#### `sources`

The picture tag uses multiple source elements with individual `src` and `media` attributes. The first source with a matching `media` attribute will be used. Each `source_*` becomes a source element in HTML.

Sources are named with the pattern `source_` plus a descriptive string. A `source_default` is required. Source names can't contain the `.`, `:`, or `/` characters.

Remember to arrange your sources from most restrictive `media` to the least restrictive. `source_default` does not accept a `media` key, and should always be last.

#### `width` and `height`

Jekyll Picture Tag uses Minimagick to automatically generate resized images for your picture sources. Set a single value to scale the image proportionately. Set both to scale and crop. Units are pixels.

#### `media`

`media` takes a CSS media query that sets the conditions under which the source will be displayed. Any CSS media query is allowed. 

## Managing Generated Images

Jekyll Picture Tag  generates resized source images every time you build your site. It uses a smart caching system to speed up site compilation, and will re-use images as much as possible.

Try to use a base image that is larger than the largest source image you'll need. Jekyll Picture Tag will warn you if a base image is too small, and won't upscale your images.

By specifying a source path that is not compiled by Jekyll you can prevent your huge base images from being copied to the compiled site. For example, `source_path: assets/_picture-source` and `output_path: assets/picture` will result in a picture directory in the compiled site that only contains your resized images.  

The `output_path` is never deleted on site compilation. You should only store generated images in the `output_path` directory. Before you commit a version of your site you may want to manually clean the directory and re-generate.

You should always use a build process to optomize your site assets, including images. If you're a cool kid you should take a look at [Yeoman](http://yeoman.io/) and [generator-jekyllrb](https://github.com/robwierzbowski/generator-jekyllrb).

## Contribute

Report bugs and feature proposals in the [Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues). In lieu of a formal styleguide, take care to maintain the existing coding style. 

## Release History

0.1.0, July 5, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)