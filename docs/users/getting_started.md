---
sort: 2
---

# Getting started

Firstly, let me warn you that responsive images are somewhat complicated, and fall squarely into
"proper web development" territory. To do this well, you will need to do some learning. The default
settings are a starting point, meant to get you up and running with something reasonable while
minimizing unexpected behavior.

Here are some good guides:

* [MDN Responsive Images guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)
* [CSS Tricks Guide to Reponsive Images](https://css-tricks.com/a-guide-to-the-responsive-images-syntax-in-html/)
* [Cloud 4 - Responsive Images 101](https://cloudfour.com/thinks/responsive-images-101-definitions/)

## Global configuration

JPT's [global configuration](configuration) happens under the `picture:` key in `_config.yml`. The
defaults are probably fine, though you may want to configure the input and output
[directories](configuration/directories).

## Test & Learn

### Hello, world!

Now's a good time to see if we're set up correctly. Drop a few test images in the site root (or
`source` directory if you configured it), pick some page and write the following (substitute the
image filename as appropriate):

{% raw %}
```
{% picture my_image.jpg %}
```
{% endraw %}

Build/serve the site and check it out! Your image should be there, and if you inspect it with the
dev tools you should see an `<img>` tag with a `srcset` attribute. You're officially serving
responsive images.

### Webp

JPT includes several built-in presets and media queries, documented in the
[examples](presets/examples). They're intended as a starting point and a learning tool, not for
production use. Don't dig to deeply into that link just yet, try them out first:

{% raw %}
```
{% picture jpt-webp my_image.jpg %}
```
{% endraw %}

Now instead of a lone `<img>` tag, you get a `<picture>` surrounding two `<source>`s and an `<img>`.
The first source contains webp images, and the second contains jpegs. Success! Lighthouse is happier
and happier.

### Alt text

Good web developers add alt text. JPT makes this easy:

{% raw %}
```
{% picture my_image.jpg --alt Happy Puppy %}
```
{% endraw %}

### Crop


{% raw %}
```
{% picture my_image.jpg 16:9 %}
```
{% endraw %}

Feeling cinematic?

### Art Direction

(Usually means "Cropping, but only sometimes.")

Art direction is tricky to understand; I know it tripped me up for awhile when learning the subject.
Here's a short explanation, along with a demo: Let's pretend that we have some image which looks
good on desktop, but on a mobile screen it's hard to see the subject. Resolution isn't the problem,
the image just needs to be cropped for smaller screens. JPT makes this easy: 

{% raw %}
```
{% picture my_image.jpg 2:1 jpt-mobile: my_image.jpg 1:1 %}
```
{% endraw %}

This tag is pretty complicated, so here's a breakdown in plain english:
* Use the default preset.
* use my_image.jpg as the base image.
* Crop it to a 2:1 aspect ratio.
* When the media query named 'jpt-mobile' is true, also use my_image.jpg
* but this time crop it square.

Now adjust the browser width. When skinny, you should see a square crop of your image, and when it's
wide you should see a 2:1 crop of the same image. That's art direction. Note that there's no
requirement at all for them to be the same image, and you don't have to use JPT to do the cropping.

There are several more liquid tag examples [here](liquid_tag/examples) that you may want to look
over, as well as the [liquid tag instructions](liquid_tag).

## Add breakpoints

Once you have a feel for how this plugin works, it's time to adapt it to your particular site. The
built-in `jpt-` media queries probably don't quite fit your layout; Find whatever breakpoints your
css uses, and tell JPT about them:

1. Create `_data/picture.yml`
2. List them under the `media_queries:` key. Give them easy-to-remember names, and wrap them in
   single quotes.

```yaml
# _data/picture.yml

media_queries:
  (name): '(media query)'
  (...)

```

If you're using bootstrap or something, you don't need to plug in every single breakpoint they have,
just a handful that you'll actually use.

## Write presets

From there, it's time to [write your own presets](presets). Start with the `default`, and then move
on to cover all the different ways you use images in your site.
