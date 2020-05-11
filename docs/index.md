---
id: quickstart
---

# Quick start / Demo

**All configuration is optional.** Here's the simplest possible use case:

1. [Install]({{ site.baseurl }}/installation)

2. Write this: {% raw %} `{% picture test.jpg %}` {% endraw %}

3. Get this:

```html
<!-- Formatted for readability -->

<img src="/generated/test-800-195f7d.jpg"
  srcset="
    /generated/test-400-195f7d.jpg   400w,
    /generated/test-600-195f7d.jpg   600w,
    /generated/test-800-195f7d.jpg   800w,
    /generated/test-1000-195f7d.jpg 1000w
    ">
```

(Along with the appropriate images, obviously.)

### "That's cool, but I just want webp."

Create `_data/picture.yml`, add the following:

```yml
markup_presets:
  default:
    formats: [webp, original]
```


### Here's a more complete demonstration:

[Presets]({{ site.baseurl }}/presets) are named collections of settings, and come in 2 kinds: Media
Presets are named CSS media queries, and Markup Presets determine the output text and images. You
choose one with the second [tag parameter]({{ site.baseurl }}/usage), or omit for the `default` (as
in these examples).  They are located in `_data/picture.yml`. Here's an example:

```yml
media_presets:
  mobile: 'max-width: 600px'

markup_presets:
  default:
    widths: [600, 900, 1200]
    formats: [webp, original]
    sizes:
      mobile: 80vw
    size: 500px
```

Imagemagick can easily crop images to an aspect ratio, though you should **read the whole
installation guide before using this feature**. With the above preset, if you write this:


{% raw %}
`{% picture test.jpg 3:2 mobile: test2.jpg 1:1 --alt Alternate Text %}`
{% endraw %}

You'll get something like this:

```html
<!-- Formatted for readability -->

<picture>
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    media="(max-width: 600px)"
    srcset="
      /generated/test2-600-21bb6fGUW.webp   600w,
      /generated/test2-900-21bb6fGUW.webp   900w,
      /generated/test2-1200-21bb6fGUW.webp 1200w
    "
    type="image/webp">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    srcset="
      /generated/test-600-195f7d192.webp   600w,
      /generated/test-900-195f7d192.webp   900w,
      /generated/test-1200-195f7d192.webp 1200w
    "
    type="image/webp">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    media="(max-width: 600px)"
    srcset="
      /generated/test2-600-21bb6fGUW.jpg   600w,
      /generated/test2-900-21bb6fGUW.jpg   900w,
      /generated/test2-1200-21bb6fGUW.jpg 1200w
    "
    type="image/jpeg">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    srcset="
      /generated/test-600-195f7d192.jpg   600w,
      /generated/test-900-195f7d192.jpg   900w,
      /generated/test-1200-195f7d192.jpg 1200w
    "
    type="image/jpeg">
  <img src="/generated/test-800-195f7dGUW.jpg" alt="Alternate Text">
</picture>
```

In other words, you have the art direction, format switching, and resolution switching problems
*solved*, with a one-liner and a nicely readable config file that is 1/3 as long as the output
markup. Lighthouse is happy, and you don't even need to crop things yourself.
