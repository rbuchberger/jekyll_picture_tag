---
---
# /_data/picture.yml

These are example settings- I mostly made them up off the top of my head. You
probably don't want to just copy-paste them. The full documentation
for these can be found [here]({{ site.baseurl }}/presets).

```yml

# Media presets are just named css media queries, used in several places:
# - To specify alternate source images (for art direction)
# - To build the 'sizes' attribute
# - When given alternate source images, specify which sizes to generate.
media_presets:
  wide_desktop: 'min-width: 1801px'
  desktop: 'max-width: 1800px'
  wide_tablet: 'max-width: 1200px'
  tablet: 'max-width: 900px'
  mobile: 'max-width: 600px'

# Markup presets allow you to group settings together, and select one of them by
# name in your jekyll tag. All settings are optional.
markup_presets:

  default:
    # What form the output markup should take:
    markup: auto

    # Must be an array, and order matters. Defaults to just 'original', which
    # does what you'd expect.
    formats: [webp, original]

    # Must be an array: which image sizes (width in pixels) to generate (unless
    # directed otherwise below). If not specified, will use sensible default
    # values.
    widths: [200, 400, 800, 1600]

    # Alternate source images (for art direction) are associated with media
    # query presets. Here, you can optionally specify a different set of sizes
    # to generate for those alternate source images.  This is how you avoid
    # generating a 1600 pixel wide image that's only shown on narrow screens.
    # Must be arrays.
    media_widths: 
      mobile: [200, 400, 600] 
      tablet: [400, 600, 800]

    # For building the 'sizes' attribute on img and source tags. specifies how
    # wide the image will be when a given media query is true. Note that every
    # source in a given <picture> tag will have the same associated sizes
    # attribute.
    sizes: 
      mobile: 100vw
      tablet: 80vw

    # Specifies an optional, unconditional size attribute. Can be given alone,
    # or if specified in combination with 'sizes' below, will be given last
    # (when no media queries apply).
    size: 800px

    # Specify the properties of the fallback image. If not specified, will
    # return a 900 pixel wide image in the original format.
    fallback_width: 800
    fallback_format: original

    # Add HTML attributes. 'parent' will go to the <picture> tag if it's there,
    # otherwise the 'img' tag.
    attributes:
      parent: 'data-downloadable="true"'
      picture: 'class="awesome" data-volume="11"'
      img: 'class="some-other-class"'
      a: 'class="image-link"'

    # This will wrap images in a link to the original source image. Obviously
    # your source images will need to be part of the deployed site for this to
    # work. If you have issues such as mangled HTML or extra {::nomarkdown}
    # tags floating around, see docs/notes.md
    link_source: true

  # This is an example of how you would create a 'multiplier' based srcset;
  # useful when an image will always be the same size on all screens (icons,
  # graphics, thumbnails, etc), but you'd like to supply higher resolution
  # images to devices with higher pixel ratios.
  icon:
    base_width: 20 # How wide the 1x image should be
    pixel_ratios: [1, 1.5, 2]
    fallback_width: 20
    attributes:
      img: 'class="icon"'

  # Here's an example of how you'd configure jekyll-picture-tag to work with
  # something like lazyload:
  # https://github.com/verlok/lazyload
  lazy:
    # data_auto gives you data-src, data-srcset, and data-sizes instead of src,
    # srcset, and sizes:
    markup: data_auto
    formats: [webp, original]
    widths: [200, 400, 600, 800]
    noscript: true # add a fallback image inside a <noscript> tag.
    attributes: 
      img: class="lazy"

  # This is an example of how you'd get generated image and a URL, and nothing
  # else.
  direct:
    markup: direct_url
    fallback_format: webp # Default original
    fallback_width: 600 # Default 800

  # Here's a naked srcset. Doesn't even give you the surrounding quotes.
  srcset:
    markup: naked_srcset
    formats: [webp] # must be an array, even if it only has one item

```
