---
---
# Migrating from 1.x to 2.x

There are a few breaking changes from 1.x versions, but they've been minimized and hopefully they
won't affect you too badly. This is a guide to transitioning an existing site; We don't go into all
the new features here, except where they replace or modify existing ones.

- For easy skimming, anything with a bullet point (like this line) is something you need to
  check/do.

## Libvips

- Install Libvips, both in development and production. Any reasonably recent version will do.

We still fall back to ImageMagick when Vips doesn't support a given image format, so there's no
reason to uninstall it. However, we no longer require version 7. Version 6+ is fine, which makes
deployments involving Ubuntu much easier.

## Jekyll 4.0+

- Update to Jekyll 4.x

We're removing support for versions of Jekyll before 4.0. I did it inadvertently awhile ago with the
fast_build setting, now it's official. If this causes you a great deal of pain, speak up and we'll
look into supporting older versions.

## Ruby 2.6+

- Ensure you're running Ruby 2.6 or later.

While Jekyll supports 2.4, it's officialy EOL and 2.5 (our previous target) is in security
maintenance only. Since I want major version releases to be as rare as possible, we're making this
move now. Again, speak up if this causes a great deal of pain.

## Image quality & write options.

- If you have set `quality:` in a preset, it will stop having an effect for webp, avif, and jp2
  images. You need to set `format_quality:` instead.

Previously, all image formats used a default quality of 75. We have now set a default quality for 3
formats:

```yml
format_quality:
  webp: 50
  avif: 30
  jp2: 30
```

Since `format_quality` overrides `quality`, your `quality` setting won't affect those formats
anymore.

- Lossless webp or avif was previously accomplished by setting quality to 100. Now, that is
accomplished with an image option:

```yml
#_data/picture.yml
presets:

  my_preset:
    image_options:
      webp:
        lossless: true
```

## Setting names changing

In `_data/picture.yml`,
- `markup_presets` is now `presets`
- `media_presets` is now `media_queries`.

Go check, especially if you've been using JPT for awhile. We renamed them several versions ago, but
the old names were still supported until now. If you get a bunch of 'preset not found' warnings,
this is probably why.


## Crop changes

- Anywhere you've set a crop geometry in any format other than `w:h`, remove or change it. This
  could be in both tags and presets.
- Anywhere you've set a crop gravity such as `north` or `southeast`, remove it. This could also be
  in both tags and presets.
- Build the site, look through cropped images and decide if you like the results. Adjust the new
  `keep` setting if desired.

We now use the Libvips smartcrop feature which does some magic to keep the most interesting part.
`gravity` is now `keep` (as in which part of the image to keep), and your options are `attention`,
`entropy`, or `centre`/`center`. The default is `attention`, and it works pretty well in my testing
so far.

If you can't get satisfactory results with those options, you'll have to use a proper editor. JPT is
not one, and the old crop feature went too far down the road of trying to be.

## Naming of presets and media queries

- If you have any presets or media queries with names that start with `jpt-`, change them.

We're cordoning off a namespace for built-in ones.
