# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

It's easy to throw an image on a webpage and call it a day. Doing justice to your users by serving
it efficiently on all browsers and screen sizes is tedious and tricky. Tedious, tricky things should be
automated.

Jekyll Picture Tag is a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com)
static site. It automatically creates resized, reformatted source images, is fully configurable,
implements sensible defaults, and solves both the art direction and resolution switching problems,
with a little YAML configuration and a simple template tag. It offers several different output
formats, and can be configured to work with JavaScript libraries such as
[LazyLoad](https://github.com/verlok/lazyload).

## Why use Jekyll Picture Tag?

**Performance:** The fastest sites are static sites, but when you plonk a 2mb picture of your dog at
the top of a blog post you're throwing it all away.

**Design:** Your desktop image may not work well on mobile, regardless of its resolution. We often
want to do more than just resize images for different screen sizes, we want to crop them or use a
different image entirely.

**Developer Sanity:** Image downloading starts before the browser has parsed your CSS and
JavaScript; this gets them on the page *fast*, but it leads to some ridiculously verbose markup.
To serve responsive images correctly, we must:

- Generate, name, and organize the required images (formats \* resolutions \* source images)
- Inform the browser about the image itself-- format, size, URI, and the screen sizes where it
  should be used.
- Inform the browser how large the space for that image on the page will be (which also probably
  has associated media queries).

It's a lot. It's tedious and complicated. Jekyll Picture Tag makes it easy.  

## Features

* Automatic generation of resized, converted image files.
* Automatic generation of complex markup in several different formats.
* No configuration required, extensive configuration available.
* `sizes` attribute assistance.
* Optionally, automatically link to the source image. Or manually link to anywhere else, with just a
  tag parameter!

## Documentation

It's all in the `docs` folder:

* [Installation](docs/installation.md)
* [Usage](docs/usage.md)
* [Global settings](docs/global_configuration.md)
* [Presets](docs/presets.md)
* [Other notes](docs/notes.md)
* [Contribute](contributing.md)
* [Release History](#release-history)
* [License](LICENSE.txt)

## Quick start / Demo

**All configuration is optional.** Here's the simplest possible use case:

Add j_p_t to your gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll_picture_tag'
end
```

Put this liquid tag somewhere:

`{% picture test.jpg %}`

Get this in your generated site:

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

### Here's a more complete example:

Create `_data/picture.yml`, add the following:

```yml
# _data/picture.yml

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

`{% picture test.jpg mobile: test2.jpg --alt Alternate Text %}`

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

Jekyll Picture Tag ultimately relies on [ImageMagick](https://www.imagemagick.org/script/index.php)
for image conversions, so it must be installed on your system. There's a very good chance you
already have it. If you want to build webp images, you will need to install a webp delegate for it
as well.

## Release History

* 1.7.0 (WIP)
  * Moderately significant refactor and code cleanup 
  * Mostly complete set of tests added
  * Documentation restructure
  * Bugfix: Fallback image width will now be checked against source image width.
  * Bugfix: Minor fix to nomarkdown wrapper output
* 1.6.0 Jul  2, 2019:
  * Missing Preset warning respects `data_dir` setting
  * Add `continue_on_missing` option
* 1.5.0 Jun 26, 2019: 
  * better `{::nomarkdown}` necessity detection
  * allow user to override `{::nomarkdown}` autodetection
* 1.4.0 Jun 26, 2019:
  * Rename gem from `jekyll-picture-tag` to `jekyll_picture_tag`, allowing us to use rubygems again.
  * Add new output format: `naked_srcset`.
* 1.3.1 Jun 21, 2019: Bugfix
* 1.3.0 Jun  7, 2019:
  * Initial compatibility with Jekyll 4.0
  * bugfixes
  * change to generated image naming-- The first build after this update will be longer, and you
    might want to clear out your generated images.
* 1.2.0 Feb  9, 2019:
  * Add nomarkdown fix
  * noscript option
  * relative url option
  * anchor tag wrappers
* 1.1.0 Jan 22, 2019:
  * Add direct_url markup format,
  * auto-orient images before stripping metadata
* 1.0.2 Jan 18, 2019: Fix ruby version specification
* 1.0.1 Jan 13, 2019: Added ruby version checking
* **1.0.0** Nov 27, 2018: Rewrite from the ground up. See the [migration guide](docs/migration.md).
* 0.2.2 Aug  2, 2013: Bugfixes
* 0.2.1 Jul 17, 2013: Refactor again, add Liquid parsing.
* 0.2.0 Jul 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.
* 0.1.1 Jul  5, 2013: Quick round of code improvements.
* 0.1.0 Jul  5, 2013: Initial release.
