---
---
# Migrating from versions < 1.0

This document details the changes from previous versions (Everything before 1.0), and how to migrate
an existing site to the new version. It won't be updated to reflect new features -- it simply
describes how to get your site working with the new version.

## Changes from previous versions:

-   The default output formats are bone-stock HTML. Picturefill, as of version 3, no longer requires
    special markup, so it remains compatible. Other javascript image solutions are supported with
    the `data_` selection of markup formats. Interchange support is removed, though adding it again
    is not difficult if there is demand for it.
-   There are now 2 basic markup formats to choose from: `<source>` tags within a `<picture>`, and a
    single `<img>` tag. If markup is set to 'auto', or if it is not set at all, the plugin will
    automatically determine which is most appropriate. These formats also have `data_` counterparts
    (i.e.  `data_auto`), which accomplish the same thing except setting respective data-attributes
    to allow for lazy loading and such.
-   There are also 2 srcset formats: one which supplies image width, and another which supplies
    multiples (pixel ratios) of the base size.
-   Source Keys are replaced by media query presets, which can also be used to create the 'sizes'
    attribute.
-   Jekyll Picture Tag no longer accepts height arguments, and will no longer crop images for you.
    Aspect ratio will always be maintained.
-   Multiple image widths are now supported, which will be used to create a corresponding srcset.
-   Multiple image formats are now possible, including webp.
-   PictureTag can now generate sizes attributes.
-   Configuration takes a very different format. It should be simpler to write your config than the
    old version, and migrating to it should not be difficult. Instead of creating individual source
    keys, you supply an array of widths you'd like to construct. You can also supply an array (yaml
    sequence) of formats, including 'original'.
-   Only global settings are placed in `_config.yml`. Presets are moved to `_data/picture.yml`.

## Migration

### Liquid Tags

Previous tag syntax has been extended, but backwards compatibility (and behaviour of previous
versions) is maintained. 

{% raw %}
`{% picture img.jpg (implicit attributes) --(argument) (explicit attributes) %}`
{% endraw %}

Implicit attributes are the old way. They are specified after the last source image, and before any
explicit attributes (if they are included). These attributes are applied to the `<img>` tag, as in
previous versions.

Explicit attributes are the new way, documented in the readme. It is possible to use a mix of both,
though I'm not sure why you would want to.

There is one instance I can think of where you will have to change your tags:

-   You use art direction with more than one different preset.
-   These presets have source keys of the same name.
-   These source keys have different associated media queries.

If all of the above are true, you will either have to pick one media query which works for both, or
rename one of them and change it everywhere it's used.

Another trouble spot will be CSS; your output markup may change, meaning your CSS selectors may stop
working.

Outside of those situations, and provided you have created media_presets to match your old source
keys, your existing tags should keep working. If they don't, it's a bug. Please report it.

### Configuration

The new configuration is described in the readme so I won't document it here, but I will show an old
config alongside an equivalent new one.

Example old configuration:

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
  # You can't specify both widths and pixel ratios anymore. Choose one.
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
