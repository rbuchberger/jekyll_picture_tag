---
sort: 8
---

# Width & Height (Anti-Loading-Jank)

_Format:_

```yml
dimension_attributes: true | false
```

_Example:_

```yml
dimension_attributes: true
```

_Default:_ `false`

Prevent page reflow (aka jank) while images are loading, by adding `width` and
`height` attributes to the `<img>` tag in the correct aspect ratio.

For an explanation of why and how you want to do this,
[here](https://youtu.be/4-d_SoCHeWE) is a great explanation.

Caveats: 
  * You need either `width: auto;` or `height: auto;` set in CSS on the `<img>`
  tags, or they will be stretched.
  * This works on `<img>` tags and `<picture>` tags when offering images in
  multiple widths and formats, but it does not work if you are using art
  direction (in other words, if you have multiple source images). This is
  because these attributes can only be applied to the `<img>` tag, of which
  there is exactly one.
