---
sort: 5
---

# Width Based Srcsets

A width based srcset looks like this:

```html
srcset="myimage-800.jpg 800w, myimage-1200.jpg 1200w, myimage-2000.jpg 2000w"
```

You should use it when the size of an image depends on the size of the screen used to show it, which
generally means anything bigger than about 300 pixels. It's the default; to use it specify a
`widths` setting (or don't, for the default set), and optionally the `sizes` and `size` settings.

## A word on sizes

The `sizes` attribute is both important, and impossible to offer good defaults for. Web browsers parse
web pages line-by-line. When they run into an external asset (such as an image) they must download,
they start that process immediately without waiting to draw the page. This means that at the point
in time when the browser must decide which image to download, it has no clue how large that image
will be on the page. The sizes attribute is how we tell it.

It doesn't have to be pixel-perfect, just close enough for the browser to make a good choice.  You
can't use % (percentage width of the parent container) for the same reason we have to do this at
all. If you do not provide it, the web browser will assume the image is 100vw (100% the width of
the viewport.)

## How to create a sizes attribute

First, Load the page and image as they will appear in the final site. (Basically write the rest of
the preset.)

Next, using either dev tools or by manipulating the browser window itself, determine how large the
image will be for all reasonable screen sizes. Organize this information into CSS measurements
(using `vw`, `vh`, `px`, `em`, or a calculation based on those units) associated with your
named CSS media queries, and enter them into the relevant preset. **Order matters**; enter these
from most to least restrictive. The browser will ignore everything after the first media query it
finds that is true.

**Example:** on my particular site, for screens 900px or smaller, inline images are the width of the
viewport minus 9px of padding on either side. For screens 901px or larger, they are a constant 862px
wide. The relevant lines in my config file look like this:

```yml
media_queries: 
  full_width: 'min-width: 901px'
  # (...)

presets:
  default:
  # (...)
  sizes:
    full_width: 862px
  size: calc(100vw - 18px)
```

## Settings Reference

### Widths

_Format:_ `widths: [integer, integer, (...)]`

_Example:_ `widths: [600, 800, 1200]`

_Default_: `[400, 600, 800, 1000]`

Array of image widths to generate, in pixels.

### Media Widths

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

If you are using art direction, there is no sense in generating desktop-size files for your mobile
image. Similarly, there's no sense in generating 300px wide versions of your ultrawide crop. You can
specify sets of widths to associate with given media queries.

### Sizes

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

Conditional sizes, used to construct the `sizes=` HTML attribute telling the browser how wide your
image will be (on the screen) when a given media query is true. CSS dimensions can be given in `px`,
`em`, or `vw`. Provide these in order of most restrictive to least restrictive. The browser will
choose the first one with an applicable media query.

### Size

_Format:_ `size: (CSS Dimension)`

_Example:_ `size: 80vw`

Unconditional `sizes` setting, to be supplied either alone or after all conditional sizes.
