---
sort: 1
---

# How to write a preset

## 0. Pick a name

* Preset names should be a single word, and they can't contain periods.
* `default` is used when you don't specify one in a liquid tag.
* Anything beginning with `jpt-` is off limits.

## 1. Pick a Markup Format

The high level, overall markup format is controlled with the `markup:` setting, documented
[here](markup_formats). You probably want the default setting of `auto`, unless you're doing some
form of post-processing.

If you have a lot of images below-the-fold, consider setting up lazy-loading with an appropriate
javascript library (there are tons) and `data_auto`.

## 2. Choose a srcset format.
 
For images that are different sizes on different screens (most images), use a [width-based
srcset](width_srcsets) (which is the default). When using this format, it's important to create a
sizes attribute, documented at the link above.

Use a [pixel-ratio srcset](pixel_ratio_srcsets) when the image will always be the same size,
regardless of screen width (thumbnails, avatars, icons, etc). 

## 3. Choose a set of image widths.

For width-based srcsets, set `widths:`. For pixel-ratio srcsets, set `base_width:` and
`pixel_ratios:`. You want 3-6 sizes that cover a wide range of devices.

## 4. Choose a set of image formats.

Accomplish this by setting `formats: [format1, format2, etc...]`

* `webp` has [broad support](https://caniuse.com/?search=webp) and is an obvious choice.
* `avif` has [bad](https://caniuse.com/?search=avif) (but improving) support, and for some reason is slow to generate, but gets better
  file sizes than webp.
* `jp2` is [Apple's baby](https://caniuse.com/?search=jp2).
* `original` spits out whatever you put in.

Order matters; browsers will use the first one they support. 

* `[webp, original]` is a good compromise of build resources, support, and performance.
* `[webp, jp2, original]` brings Safari users along for the ride.
* `[avif, original]` If you don't care about browsers that aren't chrome, or build time.
* `[avif, webp, jp2, original]` might be overkill, but it keeps everyone happy.

## 5. Consider enabling dimension attributes.

This step prevents page reflow on image load (especially when lazy loading), but requires some prep.

1. Make sure your CSS is correct. You need something like `width: 100%` and `height: auto` (which
   is why they aren't turned on by default.) Without this step, you'll get crazy sizes and/or
   stretched images.
2. Set `dimension_attributes: true`

## 6. Make any other necessary changes.

Look through the options in the sidebar to the left, adjust as required. Note that the `data_*`
output formats have a few special options, documented on their respective pages.
