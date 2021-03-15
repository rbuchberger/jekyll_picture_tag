---
sort: 3
---

# Crop

Crop an image to a given aspect ratio. This argument is given as a `crop` and (optionally) a `keep`
setting. The values given here will override the preset settings (if present), can be given after
every image, and apply only to the preceding image.

`crop` is given as an aspect ratio in the `width:height` format.

`keep` sets which portion of the image to keep; it's the
['interestingness'](https://libvips.github.io/libvips/API/current/libvips-conversion.html#VipsInteresting)
setting passed to the [libvips
smartcrop](https://libvips.github.io/libvips/API/current/libvips-conversion.html#vips-smartcrop)
function. Your options are:

* `attention` - automagically keep parts likely to draw human attention. **Default**
* `entropy` - Crop out the parts with the least variation.
* `center` or `centre` - Keep the middle part.

```note
Cropping happens before resizing; the preset `widths` setting is a post-crop value.
```

More fine-grained control is beyond the scope of this plugin. I'm not writing an image editor here!

## Examples

- `16:9`
- `1:1 entropy`
- `3:2 center`
