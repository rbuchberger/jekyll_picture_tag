---
sort: 3
---

# Crop

```warning
Ensure that both your development and production build environments have
ImageMagick 7+ installed before using this feature. Anything based on Ubuntu
likely does not. The installation guide has more information.
```

Crop an image to a given aspect ratio or size. This argument is given as a
`geometry` and (optionally) a `gravity`, which can appear in either order and
are thin wrappers around ImageMagick's
[geometry](http://www.imagemagick.org/script/command-line-processing.php#geometry)
and
[gravity](http://www.imagemagick.org/script/command-line-options.php#gravity)
settings. The values given here will override the preset settings (if present),
can be given after every image, and apply only to the preceding image.

Geometry can take many forms, but most likely you'll want to set an aspect
ratio-- given in the standard `width:height` ratio such as `3:2`. Gravity sets
which portion of the image to keep, and is given in compass directions (`north`,
`southeast`, etc) or `center` (default). Cropping happens before resizing; the
preset `widths` setting is a post-crop value.

If you'd like more fine-grained control, this can be offset by appending `+|-x`
and (optionally) `y` pixel values to the _geometry_ (not the gravity!). Example:
`1:1+400 west` means "Crop to a 1:1 aspect ratio, starting 400 pixels from the
left side.", and `north 3:2+0+100` means "Crop to 3:2, starting 100 pixels from
the top." These can get a bit persnickety; there's nothing to stop you from
running off the side of the image. Pay attention.

For detailed documentation, see ImageMagick's
[crop](http://www.imagemagick.org/script/command-line-options.php#crop) tool.

## Examples

- `16:9`
- `1:1 west`
- `3:2+20+50 northeast`

```note
If you do a lot of trial and error with these, it's a good idea to manually
delete your generated images folder more often as each change will build a new
set of images without removing the old ones.
```
