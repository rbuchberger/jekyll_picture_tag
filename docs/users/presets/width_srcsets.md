---
sort: 3
---

# Width Based Srcsets

A width based srcset looks like this: 

```html
srcset="myimage-800.jpg 800w, myimage-1200.jpg 1200w, myimage-2000.jpg 2000w"
```

It's the default; to use it specify a `widths` setting (or don't, for the
default set), and optionally the `sizes` and `size` settings.

## Widths

_Format:_ `widths: [integer, integer, (...)]`

_Example:_ `widths: [600, 800, 1200]`

_Default_: `[400, 600, 800, 1000]`

Array of image widths to generate, in pixels.

## Media Widths

_Format:_

```yml
media_widths:
  (media_query name): [integer, integer, (...)]
```

_Example:_

```yml
media_widths:
  mobile: [400, 600, 800]
```

_Default:_ `widths` setting

If you are using art direction, there is no sense in generating desktop-size
files for your mobile image. You can specify sets of widths to associate with
given media queries. If not specified, will use `widths` setting.

## Sizes

_Format:_

```yml
sizes:
  (media preset): (CSS dimension)
  (...)
```

_Example:_

```yml
sizes:
  mobile: 80vw
  tablet: 60vw
  desktop: 900px
```

Conditional sizes, used to construct the `sizes=` HTML attribute telling the
browser how wide your image will be (on the screen) when a given media query
is true. CSS dimensions can be given in `px`, `em`, or `vw`. To be used along
with a width-based srcset.

Provide these in order of most restrictive to least restrictive. The browser
will choose the first one with an applicable media query.

You don't have to provide a sizes attribute at all. If you don't, the browser
will assume the image is 100% the width of the viewport.

## Size

_Format:_ `size: (CSS Dimension)`

_Example:_ `size: 80vw`

Unconditional `sizes` setting, to be supplied either alone or after all
conditional sizes.
