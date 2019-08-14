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

[Presets]({{ site.baseurl }}/presets) are named collections of settings that tell JPT what you want it to give you.
Media presets are just CSS media queries, and markup presets determine the output text and images.
You choose one with the second [tag parameter]({{ site.baseurl }}/usage), or omit for the `default` (as in these
examples). They are located in `_data/picture.yml`. Here's an example:

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

Write this:

{% raw %}
`{% picture test.jpg mobile: test2.jpg --alt Alternate Text %}`
{% endraw %}

Get this:

```html
<!-- Formatted for readability -->

<picture>
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    media="(max-width: 600px)"
    srcset="
      /generated/test2-600-21bb6f.webp   600w,
      /generated/test2-900-21bb6f.webp   900w,
      /generated/test2-1200-21bb6f.webp 1200w
    "
    type="image/webp">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    srcset="
      /generated/test-600-195f7d.webp   600w,
      /generated/test-900-195f7d.webp   900w,
      /generated/test-1200-195f7d.webp 1200w
    "
    type="image/webp">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    media="(max-width: 600px)"
    srcset="
      /generated/test2-600-21bb6f.jpg   600w,
      /generated/test2-900-21bb6f.jpg   900w,
      /generated/test2-1200-21bb6f.jpg 1200w
    "
    type="image/jpeg">
  <source
    sizes="(max-width: 600px) 80vw, 600px"
    srcset="
      /generated/test-600-195f7d.jpg   600w,
      /generated/test-900-195f7d.jpg   900w,
      /generated/test-1200-195f7d.jpg 1200w
    "
    type="image/jpeg">
  <img src="/generated/test-800-195f7d.jpg" alt="Alternate Text">
</picture>
```
