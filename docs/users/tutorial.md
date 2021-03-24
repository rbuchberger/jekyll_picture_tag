---
sort: 3
---

# Tutorial

## Hello, world!

Once you've followed the [installation](installation) instructions, it's a good
time to make sure we're set up correctly. Drop an image or two in the site root
(or `source` directory if you [configured it](configuration/directories)), pick
some page and write the following (substitute the image filename as
appropriate):

{% raw %}
```
{% picture my_image.jpg %}
```
{% endraw %}

Build/serve the site and check it out! Your image should be there, and if you inspect it with the
dev tools you should see an `<img>` tag with a `srcset` attribute. You're officially serving
responsive images.

## Webp

JPT includes several built-in presets and media queries, documented in the
[examples](presets/examples). They're intended as a starting point and a learning tool, not for
production use. Don't dig to deeply into that link just yet, try them out first:

{% raw %}
```
{% picture jpt-webp my_image.jpg %}
```
{% endraw %}

Now instead of a lone `<img>` tag, you get a `<picture>` surrounding two `<source>`s and an `<img>`.
The first source contains webp images, and the second contains jpgs. Success! Lighthouse is happier
and happier.

## Alt text

Good web developers add alt text. JPT makes this easy:

{% raw %}
```
{% picture my_image.jpg --alt Happy Puppy %}
```
{% endraw %}

## Crop


{% raw %}
```
{% picture my_image.jpg 16:9 %}
```
{% endraw %}

Feeling cinematic? If you don't like how the image gets cropped, you can adjust it:

{% raw %}
```
{% picture my_image.jpg 16:9 center %}
```
{% endraw %}

Your options are `attention` (which is the default), `entropy`, and `center`.

## Art Direction

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
