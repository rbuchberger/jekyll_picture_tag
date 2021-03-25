---
sort: 6
---

# Pixel Ratio Srcsets

A Pixel Ratio srcset looks like this:

```html
srcset="myimage-200.jpg 1.0x, myimage-300.jpg 1.5x, myimage-400.jpg 2.0x" 
```

To use one, set `pixel_ratios` and `base_width`. They are most appropriate for
thumbnails and icons, where the image will be the same size on all screens, and
all you need to account for is pixel ratio.

## Base Width

_Format:_ `base_width: integer`

_Example:_ `base_width: 100`

Sets how wide the 1x image should be. Required when using a Pixel Ratio srcset.

## Pixel Ratios

_Format:_ `pixel_ratios: [number, number, number (...)]`

_Example:_ `pixel_ratios: [1, 1.5, 2]`

Array of images to construct, given in multiples of the base width.

