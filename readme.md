# Jekyll Picture Tag

**Tagline**

Jekyll Picture Tag adds a responsive image tag to the [Jekyll](http://jekyllrb.com) static site generator. It's fully configurable, generates multiple images for you, and covers all use cases — including art direction and resolution switching — with a simple template tag.

```
{% picture gallery archive/poster.jpg class="poster-photo" alt="The strange case of responsive images" %}
```

## Installation

Make sure you have [Jekyll](http://jekyllrb.com) `>=1.0` and [Minimagick](https://github.com/minimagick/minimagick) `>=3.6` installed.  
Copy picture_tag.rb into your Jekyll _plugins folder.  

[edit] add minimagick/imagemagick instructions?
brew up
brew install ImageMagick
or download the binary from http://www.imagemagick.org/script/binary-releases.php

## Usage

There are three parts to Jekyll Picture Tag: the polyfill, the tag, and the settings.

### Picturefill

The tag requires [Picturefill](https://github.com/scottjehl/picturefill) to polyfill the proposed picture element. Download the library and add it to your site.

### The Tag

```
{% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute="value"] %}
```

The tag takes a mix of user input and pointers to _config.yml settings to make outputting complex markup easy. Tag parts can be separated by spaces or line breaks. Let's break it down.

#### picture

`picture` tells Liquid this is a Jekyll Picture Tag.

#### preset_name

Optionally specify a picture preset from the _config.yml.  
Defaults to the `default` preset.

#### path/to/img.jpg

Specify an image relative to the `picture[src]` setting in _config.yml.  
?? Any file type supported by Minimagick is allowed.
[edit] must be local filesystem, no http/s image locations

#### source_key: path/to/alt/img.jpg

Optionally specify an alternate image for a picture source. Enjoy your art direction!

#### attributes

Optionally specify HTML attributes for the picture. These will be merged with any attributes you've set in the _config.yml. `data-picture`, `data-alt`, `data-src`, and `data-media` are reserved and can't be used.

### Settings

Jekyll Picture Tag stores settings and picture presets in _config.yml. It takes a few minutes to set up your presets, but after that generating complex markup with a simple liquid tag is easy. All settings are stored under the `picture` key. 

**Example settings**

```yml
picture:
  asset_path: "assets/images"
  generated_path: "assets/images/generated"
  markup: picturefill
  presets:
    default:
    ...
    gallery:
    ...
    portrait:
    ...
```

**Example preset**

```yml
gallery:
  ppi: [1, 1.3, 2]
  attr:
    itemprop: "image"
  source_medium:
    media: "(min-width: 60em)"
    width: "750"
  source_default:
    width: "500"
    height: "200"
```

#### asset_path

To make it easier to add images, you can specify an asset path that will be prepended to any image source in the picture tag...

The directory to look for source images in, relative to Jekyll's source directory.  

#### generated_path

The directory to output generated images to, relative to Jekyll's source directory. Generated images are created in Jekyll's source directory so they can be cached for the future.  
Defaults to `generated` inside of the `src` directory.

#### markup

The markup to output.  
Allowed values: `picturefill` (markup for Scott Jehl's Picturefill polyfill) or `picture` (the proposed picture and source elements).  
Defaults to `picturefill`.

#### presets

Presets hold the configuration for a picture tag.

#### preset name

A preset name can't contain the `.` or `:` characters.  
The `default` preset is required.

#### attr

You can optionally set a list of attributes to add to every tag generated with this preset. Attributes specified in the tag will override these settings. You can set any attribute except for `data-picture`, `data-alt`, `data-src`, and `data-media`.

#### ppi

A shorthand to generate resolution alternates for your source keys. The setting `[1, 1.3]` will create sources that switch to 1.3x sized images on devices with a minimum dppx of 1.3. For finer grained control omit the `ppi` key and write out resolution sources by hand.

[edit] ppi max decimal depth = 2

#### source_key

Source keys generate the sources for the picture tag. The `source_default` key is required. Source keys are named with the pattern `source_` plus a descriptive string, and can't contain the `.` or `:` characters. Sources also can't be named `attr` or `ppi`. They're rendered in the order you list them.

[edit] Picture uses the first source that matches, so order your sources appropriately. If you're doing mobile first, the largest, highest resolution media source should be first.

#### width and height

Jekyll Picture Tag uses the Minimagic Ruby library to automatically generate resized images for your picure sources. Set either `width` or `height` to scale the picture. Set both to scale and crop. Units are pixels.

#### media

`media` takes a CSS media query that sets the conditions under which the source will be displayed. Any CSS media query is allowed. `source_default` does not accept a `media` key.

## Notes

## License

BSD-NEW