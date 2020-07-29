---
sort: 3
---

# Writing Presets

Presets are named collections of settings that determine basically everything
about JPT's output. Think of them like frameworks that you can plug images into;
the preset determines what markup, what image sizes, and what image formats to
create, while the picture tag determines which image(s) will be used.  They are
stored in `_data/picture.yml`. You will have to create this file, and probably
the `_data/` directory as well.

Any settings which are specific to particular markup formats are documented on
their respective markup format page.

## Required Knowledge

If you don't know the difference between resolution switching and art direction,
stop now and learn responsive images. Ideally, write a few yourself until you
understand them.

Here are some good guides:

* [MDN Responsive Images guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)
* [CSS Tricks Guide to Reponsive Images](https://css-tricks.com/a-guide-to-the-responsive-images-syntax-in-html/)
* [Cloud 4 - Responsive Images 101](https://cloudfour.com/thinks/responsive-images-101-definitions/)

## Media Queries

**Media queries are not presets**, but they are used when writing them. They are
defined in `_data/picture.yml` alongside presets. More information
[here](media_queries).

## Presets

_General Format:_

```yaml
# _data/picture.yml

presets:
  (name):
    (option): (setting)
    (option): (setting)
    (...)
  (...)
```

_Example:_

```yaml
# _data/picture.yml

presets:
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

Each entry is a pre-defined collection of settings to build a given chunk of
text (usually HTML) and its respective images. You can select one as the first
argument given to the tag:

{% raw %}
`{% picture my-preset image.jpg %}`
{% endraw %}

The `default` preset will be used if none is specified. A preset name can't
contain a `.` (period). You can create as many as you like.

```note
`media_queries` and `presets` used to be called `media_presets` and
`markup_presets`.  These names were causing some confusion, so they were
changed. The old names will continue working for the forseeable future, at least
until the next major version update.
```

## Markup Format

The high level, overall markup format is controlled with the `markup:` setting,
documented [here](markup_formats).

## Choosing a Srcset format
 
For images that are different sizes on different screens (most images), use a
[width-based srcset](width_srcsets) (which is the default). 

Use a [pixel-ratio srcset](pixel_ratio_srcsets) when the image will always be
the same size, regardless of screen width (thumbnails and icons). 

## Settings reference

{% include list.liquid %}
