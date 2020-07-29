---
sort: 12
---
# Example _data/picture.yml

These are example settings- I mostly made them up off the top of my head. You
probably don't want to just copy-paste them.

```yaml
# _data/picture.yml

media_queries:
  wide_desktop: 'min-width: 1801px'
  desktop: 'max-width: 1800px'
  wide_tablet: 'max-width: 1200px'
  tablet: 'max-width: 900px'
  mobile: 'max-width: 600px'

presets:
  default:
    markup: auto
    link_source: true # wrap images in a link to the original source image.
    dimension_attributes: true # Page reflow begone!

    formats: [webp, original] # Must be an array, and order matters.

    widths: [200, 400, 800, 1600] # Must be an array.
    media_widths: # Because a cell phone doesn't want 1600 pixels.
      mobile: [200, 400, 600] 
      tablet: [400, 600, 800]

    sizes: 
      mobile: 100vw
      tablet: 80vw
    size: 800px

    fallback_width: 800
    fallback_format: original

    attributes:
      parent: 'data-downloadable="true"'
      picture: 'class="awesome" data-volume="11"'
      img: 'class="some-other-class"'
      a: 'class="image-link"'

  # This is an example of how you would create a 'multiplier' based srcset;
  # useful when an image will always be the same size on all screens (icons,
  # graphics, thumbnails, etc), but you'd like to supply higher resolution
  # images to devices with higher pixel ratios.
  icon:
    base_width: 20 # How wide the 1x image should be.
    pixel_ratios: [1, 1.5, 2]
    fallback_width: 20
    attributes:
      img: 'class="icon"'

  # Here's an example of how you'd configure jekyll-picture-tag to work with
  # something like lazyload: https://github.com/verlok/lazyload
  lazy:
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
    fallback_format: webp
    fallback_width: 600

  # Here's a naked srcset. Doesn't even give you the surrounding quotes.
  srcset:
    markup: naked_srcset
    formats: [webp] # must be an array, even if it only has one item

```
