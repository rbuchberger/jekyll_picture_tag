---
sort: 2
---
# Examples

The following example media queries & presets (except for `default`) are built-in with a `jpt-`
prefix. For example, the `desktop` media query below can be used with `jpt-desktop`, and the `webp`
preset below can be used with `jpt-webp`.

```yaml
# _data/picture.yml

# These are used in several places. You likely want to enter whatever CSS media queries your site
# uses here.
media_queries:
    mobile: 'max-width: 480px'
    tablet: 'max-width: 768'
    laptop: 'max-width: 1024px'
    desktop: 'max-width: 1200'
    wide: 'min-width: 1201'

presets:
  # This entry is purely an example. It is not the default JPT preset, nor is it available as a
  # built-in.
  default:
    formats: [webp, original] # Order matters!
    widths: [200, 400, 800, 1200, 1600] # Image widths, in pixels.

    # The sizes attribute is both important, and impossible to offer good defaults for. You need to
    # learn about it. Short version: Web browsers parse web pages line-by-line. When they run into
    # an external asset they must download, they start that process immediately, without waiting to
    # finish rendering the page. This means that at the point in time when the browser must decide
    # which image to download, it has no clue how large that image will be on the page. The sizes
    # attribute is how we tell it.
    #
    # If you do not provide this, the web browser will assume the image is 100vw (100% the width of
    # the viewport.)
    #
    # This doesn't have to be pixel-perfect, just close enough for the browser to make a good
    # choice. Keys are media queries defined above, values are how large the image will be when
    # that media query is true. You can't use % (percentage width of the parent container) for the
    # same reason we have to do this at all.
    sizes:
      mobile: calc(100vw - 16px)
      tablet: 80vw

    # Size is unconditional; provided either after all conditional sizes (above) or alone. If you
    # only have a 'size' (no 'sizes'), and it's a constant (px, em, or rem), you should use a
    # pixel-ratio srcset.
    size: 800px

    link_source: true # wrap images in a link to the original source image.
    dimension_attributes: true # Page reflow begone!

    # You can add any HTML attribute you like, to any HTML element which JPT creates:
    attributes:
      # parent refers to the outermost tag; <picture> if it's present, otherwise the <img>.
      parent: 'data-downloadable="true"'
      picture: 'class="awesome" data-volume="11"'
      img: 'class="some-other-class"'
      a: 'class="image-link"'

  # You can use this as jpt-webp. All following presets follow the same pattern.
  webp:
    formats: [webp, original]

  # Avif is the new hotness coming down the pipe. Browser support is bad and they are slow to
  # generate, but you get good file sizes even compared to webp of similar quality.
  avif:
    formats: [avif, webp, original]

  # Your build times will suffer, but everyone is happy.
  loaded:
    formats: [avif, jp2, webp, original]
    dimension_attributes: true

  # This is an example of how you would create a 'multiplier' based srcset; useful when an image
  # will always be the same size on all screens (icons, graphics, thumbnails, etc), but you'd like
  # to supply higher resolution images to devices with higher pixel ratios.
  thumbnail:
    base_width: 250 # How wide the 1x image should be.
    pixel_ratios: [1, 1.5, 2] # Which multipliers to target.
    fallback_width: 250 # The default is 800, which is probably too big.
    formats: [webp, original]
    attributes:
      picture: 'class="thumbnail"'

  # Another pixel-ratio example.
  avatar:
    # Say your layout demands a square:
    crop: 1:1
    base_width: 100
    pixel_ratios: [1, 1.5, 2]
    fallback_width: 100,

  # Here's an example of how you'd configure JPT to work with something like lazyload:
  # https://github.com/verlok/lazyload
  # Remember to add a sizes attribute, unless it's close to 100vw all the time.
  lazy:
    markup: data_auto
    formats: [webp, original]
    noscript: true # add a fallback image inside a <noscript> tag.
    attributes:
      parent: class="lazy"

  # This is an example of how you'd get a single generated image, a URL, and nothing else.
  direct:
    markup: direct_url
    fallback_format: webp
    fallback_width: 600
```
