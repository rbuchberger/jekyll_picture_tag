---
sort: 15
---

# Aliases & Subpresets

If you're making more than one preset, you probably have things you'd prefer to not copy to every preset. Maybe some finely tuned quality settings, or different variations and crops. Thankfully, YAML has an anchor & alias feature to help with this.

Anchors are defined with a `&` and a name, placed after a key, but before the value. For the sake of example, we've defined a quality for JPEG, and given it the anchor "high_quality".

```yml
  default: 
    format_quality:
      jpg: &high_quality 90
```

With our anchor added, we can refer back to it with an alias. These are in the same format, but we use a `*` instead. (and we don't place a value, since we're making the alias our value!)

```yml
  logo: 
    format_quality:
      jpg: *high_quality
```

Now any time we change our default quality, the quality in the logo preset will be updated too!


## Subpresets

Where this feature really gets powerful, is the ability to base a preset entirely off another.

In the block below, we've created a base preset, which we'll build every other one upon. We can override any of the values later on, if we want to.

```yml
  base: &base
    formats: [webp, original]
    format_quality:
      webp: 90
    attributes:
      img: 'loading="lazy"'
```

Now we can use the special merge key, `<<`, which will copy all values from an aliased map into the new one.

```yml
  default:
    <<: *base
    widths: [500, 600, 700, 800, 900, 1000, 1200, 1600]
    link_source: true

  project_showcase:
    <<: *base
    widths: [700, 864, 900, 1296, 1600, 1728]
```

Since both of these new presets merge our base preset, the final result will be parsed like this:

```yml
  default:
    formats: [webp, original]
    format_quality:
      webp: 90
    attributes:
      img: 'loading="lazy"'
    widths: [500, 600, 700, 800, 900, 1000, 1200, 1600]
    link_source: true

  project_showcase:
    formats: [webp, original]
    format_quality:
      webp: 90
    attributes:
      img: 'loading="lazy"'
    widths: [700, 864, 900, 1296, 1600, 1728]
```

Note however, this is **not a deep merge**, only a shallow merge. What that means is, any values nested in the preset will be overwritten by the presence of a key. If we bring back our previous example, but add an attribute to it:

```yml
  project_showcase:
    <<: *base
    widths: [700, 864, 900, 1296, 1600, 1728]
    attributes:
      picture: 'class="showcase"'
```

You'll notice that, although we didn't change the `img` attributes, the parsed result will be **missing the attributes from the parent preset**, like this:

```yml
  project_showcase:
    formats: [webp, original]
    format_quality:
      webp: 90
    attributes:
      picture: 'class="showcase"'
    widths: [700, 864, 900, 1296, 1600, 1728]
```
