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

## Step 1: Customize global settings

JPT's [global configuration](configuration) happens under the `picture:` key in `_config.yml`. The
defaults are probably fine, though you may want to configure the input and output
[directories](configuration/directories).

## Step 2: Test & Learn

- If you're not already familiar, there's a short [tutorial](tutorial) to get you started with the basics.
- Look over the [example presets](presets/examples)
- Look over the [example liquid tags](liquid_tag/examples) and [instructions](liquid_tag).

## Step 3: Add breakpoints

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

## Step 4: Write presets

From there, it's time to [write your own presets](presets). Start with the `default`, and then move
on to cover all the different ways you use images in your site.
