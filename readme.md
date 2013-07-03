# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

Jekyll Picture Tag lets you use responsive images on your [Jekyll](http://jekyllrb.com) static site. It follows the proposed `<picture>` element pattern, and polyfills the functionality in current browsers with [Picturefill](https://github.com/scottjehl/picturefill). Jekyll Picture Tag is fully configurable, automatically creates resized source images, and covers all use cases — including art direction and resolution switching — with a little YAML configuration and a simple template tag.

## Rationale

**Performance:** Static sites can be can be blazingly fast. We shouldn't throw those performance gains away serving kb of pixels a user will never see. 

**Proof:** The `<picture>` element covers more responsive image use cases than any other proposed solution. As a result the markup is a bit more verbose. This plugin shows that in practice `<picture>` can be easily used and maintained by website authors.

For an introduction to the `<picture>` element and responsive images in general see [Mo’ Pixels Mo’ Problems](http://alistapart.com/article/mo-pixels-mo-problems) and the follow up article [Ughck. Images](http://daverupert.com/2013/06/ughck-images/) by [Dave Rupert](https://twitter.com/davatron5000).

## Installation

Jekyll Picture Tag requires [Jekyll](http://jekyllrb.com) `>=1.0`, [Minimagick](https://github.com/minimagick/minimagick) `>=3.6`, and [Imagemagick](http://www.imagemagick.org/script/index.php).  
Once those are installed, copy picture_tag.rb into your Jekyll _plugins folder.

## Usage

There are three parts to Jekyll Picture Tag: 

- [Polyfill](#polyfill)  
- [Tag ](#tag)  
- [Configuration](#configuration)  

### Polyfill

The default `picturefill` markup requires Scott Jehl's [Picturefill](https://github.com/scottjehl/picturefill). Download the library and add it to your site.

### Tag

```
{% picture [preset] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute="value"] %}
```

The tag takes a mix of user input and pointers to configuration settings.

#### `picture`

Tells Liquid this is a Jekyll Picture Tag.

#### `preset`

[Presets are part of the _config.yml](#presets). Optionally specify a picture preset to use, or leave blank for the `default` preset.

#### `path/to/img.jpg` 

Choose a base image to use for the picture. All source images will be resized from this one, so make sure it is large enough.  

#### `source_key: path/to/alt/img.jpg`

[Sources are part of the _config.yml](#sources). Optionally specify an alternate base image for a picture source. Enjoy your art direction!

#### `attribute="value"`

Optionally specify any number of HTML attributes. These will be merged with any attributes you've [set in the _config.yml](#attr). You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

### Configuration

Jekyll Picture Tag stores configuration in your site's _config.yml under the `picture` key. It takes a minute to set up your presets, but after that generating complex markup with a single liquid tag is easy.

**Example settings**

```yml
picture:
  asset_path: "assets/images"
  generated_path: "assets/images/generated"
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
    class: "galery-pict"
    itemprop: "image"
  source_medium:
    media: "(min-width: 40em)"
    width: "600"
    height: "300"
  source_default:
    width: "300"
    height: "150"
```

#### `asset_path`

To make it easier to write tags, you can specify a base directory for your assets. All image paths will be relative to this directory. 

For example if you set `asset_path: assets/images`, the `{% picture posters/dr_jekyll.jpg %}` tag will look for a file at `assets/images/posters/dr_jekyll.jpg`.

Defaults to the Jekyll root directory.

#### `generated_path`

Jekyll Picture Tag automatically generates images based on your settings when you build the site. These are output to the `generated_path` directory. Defaults 

Defaults to `{asset_path}/generated`.

#### `markup`

The markup to output. `picturefill` outputs markup for the Picturefill polyfill. `picture` outputs the proposed `<picture>` element markup.  

Defaults to `picturefill`.

#### `presets`

Presets are reusable picture tag styles that are referenced in the liquid tag. The `default` preset is required. A preset name can't contain the `.` or `:` characters.

#### `attr`

Each preset can have an optional list of HTML attributes associated with it. These attributes will be automatically inserted into the tag when the preset is used. 

Any attribute also set in a tag will override an attribute set in `attr`. For standalone attributes set the value to `nil`. You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

#### `ppi`

The `ppi` array automatically generates resolution versions of your sources and images. The setting `[1, 1.5]` will create sources that switch to 1.5x sized images on devices with a minimum resolution of 1.5dppx. For finer grained control omit `ppi` and write resolution sources by hand.

#### `sources`

The `<picture>` tag uses multiple source elements with individual `src` and `media` attributes. The first source with a matching `media` attribute will be used. Each `source_*` becomes a source in html.

Source keys are named with the pattern `source_` plus a descriptive string. They can't contain the `.` or `:` characters.

#### `width` and `height`

Jekyll Picture Tag uses Minimagick Ruby library to automatically generate resized images for your picture sources. Set a single value to scale the image proportionately. Set both to scale and crop. Units are pixels.

#### `media`

`media` takes a CSS media query that sets the conditions under which the source will be displayed. Any CSS media query is allowed. 

You should arrange your sources from most restrictive `media` to the least restrictive. `source_default` does not accept a `media` key, and should always be last.

## Managing Generated Images

Jekyll Picture Tag generates source images for you every time you build your site. It uses a smart caching system to make sure it doesn't generate the same image twice, and will re-use images as much as possible.

Try to use a base image that is larger than the largest source image you'll need. Jekyll Picture Tag will warn you if a base image is too small, and won't upscale your images.

You should only store generated images in the `generated_path` directory. The plugin never deletes images, so every once in a while you may want to manually clean the directory and re-generate.

## Contribute

Report bugs and feature proposals in the [Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues). In lieu of a formal styleguide, take care to maintain the existing coding style. 

## Release History

0.1.0, July 3, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)