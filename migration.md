# Update and Migration guide

This document details the changes from previous versions (Everything before 1.0), and how to migrate
an existing site to the new version. For now it's a markdown document, once this branch is merged
into master it'll be a wiki page.

## Motivation

Most importantly, I want to thank Rob Wierzbowski and all the original contributors.  While the
changes in this version are very extensive, its roots are still based in the purpose and approach of
the original.

Jekyll Picture Tag's last update was in October 2015. While the plugin grew stale, its application
certainly didn't; doing responsive images correctly is still involved, tedious, and tricky, and
there are still a few people out there building Jekyll sites.

Browser adoption of `picture`, `source`, `srcset`, and `sizes` is far better when this plugin was
first written. Firefox gained support in May of 2015, Safari in October of 2015, and Edge in october
of 2017. As of November 2018, all major, modern browsers have support and caniuse reports global
compatibility at 88%. 

PictureTag's previous versions supported a few javascript solutions, but they didn't do a great job 
supporting stock HTML (which, given browser suppport, was the most appropriate decision at the time).
That situation has now changed; standard HTML should be considered its core functionality, while 
maintaining the ability to support javascript-based solutions in the future.

## Goals

These were the objectives of the rewrite:

-   Do not stray beyond the original objective of this plugin: **Automate the creation of responsive
    image files and their associated markup.** In other words, do one thing well.
-   Maintain backwards compatibility with the old liquid tag syntax, to save website maintainers from
    needing changes made across their entire website.
-   Streamline the configuration process, ideally make all configuration optional. In the absence of
    explicit instruction, do something reasonable.
-   Enable multiple image formats (specifically webp). Generalize and modularize the code which
    generates output markup formats, to simplify the addition of new ones.
-   Break up the original plugin, which consists of ~250 (very long) lines split across only 3
    functions, into something more manageable.

## Changes

-   In version 1.0.0, only bone-stock HTML markup formats are included. However, the plugin's new
    architecture should simplify the addition of new ones.
-   There are now 2 markup formats to choose from: `<source>` tags within a `<picture>`, and a single
    `<img>` tag. If markup is set to 'auto', or if it is not set at all, the plugin will automatically
    determine which is most appropriate.
-   There are also 2 srcset formats: one which supplies image width, and another which supplies
    multiples (pixel ratios) of the base size.
-   Jekyll Picture Tag no longer accepts height arguments, and will no longer crop images for you.
    Aspect ratio will always be maintained.
-   Configuration takes a very different format. It should be simpler to write your config than the
    old version, and migrating to it should not be difficult. Instead of creating individual source
    keys, you supply an array of widths you'd like to construct. You can also supply an array (yaml
    sequence) of formats, including 'original'.
-   Only global settings are placed in `_config.yml`. Presets are moved to `_data/picture.yml`.
-   Source Keys are replaced by media query presets, which can also be used to create the 'sizes'
    attribute.

## Migration

### Liquid Tags

Previous tag syntax has been extended, but backwards compatibility (and behaviour of previous
versions) is maintained. 

`{% picture img.jpg (implicit attributes) --(argument) (explicit attributes) %}`

Implicit attributes are the old way. They are specified after the last source image, and before any
explicit attributes (if they are included). These attributes are applied to the `<img>` tag, as in
previous versions.

Explicit attributes are the new way, documented in the readme. It is possible to use a mix of both,
though I'm not sure why you would want to.

There is one instance I can think of where you will have to change your tags:

* You use art direction with more than one different preset.
* These presets have source keys of the same name.
* These source keys have different associated media queries.

If all of the above are true, you will either have to pick one media query which works for both, or
rename one of them and change it everywhere it's used.

Outside of that situation, or if different markup breaks your CSS, existing tags should keep
working. If they don't, it's a bug. Please report it.

### Configuration

The new configuration is described in the readme so I won't document it here, but I will show an old
config alongside an equivalent new one.

Example old configuration (taken from the old example config):

```yml
# _config.yml

picture:
  source: assets/images/_fullsize
  output: generated
  markup: picture
  presets:
    # Full width pictures
    default:
      ppi: [1, 1.5]
      attr:
        class: blog-full
        itemprop: image
      source_lrg:
        media: "(min-width: 40em)"
        width: 700
      source_med:
        media: "(min-width: 30em)"
        width: 450
      source_default:
        width: 350
        height: 200
    # Half width pictures
    half:
      ppi: [1, 1.5]
      attr:
        data-location: "{{location}}"
        data-active: nil
      source_lrg:
        media: "(min-width: 40em)"
        width: 400
      source_med:
        media: "(min-width: 30em)"
        width: 250
      source_default:
        width: 350
    # Self-set resolution sources. Useful if you don't want a 1:1 image size to dppx ratio.
    gallery:
      source_wide_hi:
        media: "(min-width: 40em) and (min-resolution: 1.5dppx)"
        width: 900
        height: 600
      source_wide:
        media: "(min-width: 40em)"
        width: 600
        height: 400
      source_default:
        width: 250
        height: 250

```

Equivalent new configuration:

```yml

# _config.yml

picture:
  source: assets/images/_fullsize
  output: generated

```

```yml

# _data/picture.yml

# Media presets are named media queries. To maintain compatibility with your tags, you need to
# create presets of the same name as your old source keys. There is no limit to how many of them you
# can have, so you're free to create additional new ones with better names to use going forward.
media_presets:
  source_lrg: '(min-width: 40em)'
  source_med: '(min-width: 30em)'
  source_wide_hi: "(min-width: 40em) and (min-resolution: 1.5dppx)"
  source_wide: "(min-width: 40em)"

markup_presets:
  # Note that most of these examples don't include a 'sizes' attribute, which you probably want.
  #
  # You can't specify both widths and pixel ratios anymore. Choose one.
  #
  # Full width pictures, width-based srcset
  default:
    markup: picture
    widths: [350, 450, 700]
    attributes:
      picture: 'class="blog-full" itemprop="image"'
      
  # Full width pictures, multiplier based srcset
  default-ppi:
    markup: picture
    base_width: 350
    pixel_ratios: [1, 1.5]
    attributes:
      picture: 'class="blog-full" itemprop="image"'

  # Half width pictures
  half:
    widths: [250, 350, 400]
    attributes: 
      picture: 'data-location="{{location}}" data-active="nil"'

  # Note you can't set heights anymore. You'll have to crop your images either ahead of time, or
  # do it with CSS.
  # 
  # You have to use arrays for widths, even if only specifying a single value. There's no reason you
  # can't add more.
  gallery:
    widths: [250]
    media_widths:
      source_wide_hi: [900]
      source_wide: [600]

```
