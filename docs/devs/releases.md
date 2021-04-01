---
---
# Release History

* 2.0.3 April 1, 2021
  * Improve backend format support detection
* 2.0.2 March 31, 2021
  * Do not pass a quality argument when generating PNG files.
    * It only works on newer versions of vips, breaking builds when using older
      versions (such as when deploying to netlify.)
    * It's not remarkably useful in the first place.
* 2.0.1 March 31, 2021
  * Select imagemagick deliberately when appropriate, rather than simply rescuing all vips errors
    and trying again. This will stop JPT from suppressing useful vips errors.
* **2.0** March 25, 2021 - [Migration guide](/jekyll_picture_tag/users/notes/migration_2)
  * Switch from ImageMagick to libvips.
    * 🚀🔥🔥**MUCH MORE FASTER**🔥🔥🚀
    * Will still attempt to use imagemagick if libvips cannot handle a
      particular image format.
    * Eliminate the ImageMagick v7 on Ubuntu pain we've been dealing with for so
      long.
  * Require Ruby >= 2.6, support Ruby 3.0
  * Require Jekyll >= 4.0
  * Cropping is changing.
      * We now use the libvips
        [smartcrop function](https://www.rubydoc.info/gems/ruby-vips/Vips/Image#smartcrop-instance_method),
        which does some magic to keep the most useful part of the image.
      * Geometry is renamed to 'crop', and reduced to simple aspect ratios only. (`width:height`)
      * Gravity is gone, replaced by 'keep' which is translated to a libvips
        [interestingness](https://www.rubydoc.info/gems/ruby-vips/Vips/Interesting) setting.
  * Add stock presets and media queries, under the `jpt-` prefix.
  * Add `format_quality` default settings for webp, avif, and jp2.
  * Add image-format-specific write options.
  * Overhaul user input handling; we can now validate inputs and give error
    messages which are less useless. Stronger validation and nicer errors will be added in future
    releases.
  * Drop support for `markup_presets` and `media_presets`. They are now
    officially and only `presets` and `media_queries`.
  * Improve docs with an introductory tutorial and 'how-to' flow.
* 1.14.0 January 10, 2021
  * Gracefully handle empty tag arguments.
  * Re-add metadata stripping. I removed it inadvertently when refactoring; now
    there's a test and a setting to turn it off.
  * Respect Jekyll's `--disable-disk-cache` argument.
  * Add baseurl configuration, allowing increased plugin support (such as I18n via `jekyll-multiple-languages-plugin`)
  * Tooling & test suite maintenance and improvements.
* 1.13.0 November 23, 2020
  * Add image quality interpolation; allows for variable image quality based on image size.
  * Bugfix: Perform format, resize, and quality changes simultaneously rather than individually.
    * Allows for actual lossless webp: simply set quality to 100.
    * Improves fresh (no cached images) build times by ~15%
    * Fix problems with poor image quality.
* 1.12.0 July 30, 2020
  * Documentation overhaul. Now with 87% less scrolling!
  * Rename `markup_presets` and `media_presets` to `presets` and
    `media_queries`. The old names were bad and caused confusion. The old names
    will continue to work until the next major version is released.
* 1.11.0 July 27, 2020
  * **Width and height attribute support!** Begone, page reflow.
  * Cache image information between builds
  * Change image naming format. This update will trigger all images to be
    regenerated, so you may want to delete your generated images folder
    beforehand.
* 1.10.2 July 6, 2020
  * Bugfix for fallback image files not actually getting generated
* 1.10.1 July 2, 2020
  * Bugfix for erroneously regenerated images
* 1.10.0 May 11, 2020
  * **Image Cropping support!** access the power of ImageMagick's `crop` function.
  * Don't issue a warning when `default` preset is not found.
  * Documentation improvements
* 1.9.0 Feb 2, 2020
  * Add `fast_build` global setting
  * Add `disabled` global setting
  * Reduce unnecessary disk IO; sites with many source images should see build
  times improve when no new images need to be generated.
  * Add support for empty attributes; specifically so best-practice for
    decorative images (`alt=""`) is possible.
* 1.8.0 Nov 25, 2019
  * Add `data_sizes` setting for the `data_` family of output formats.
* 1.7.1 Nov 14, 2019
  * Fix some HTML attribute related bugs
  * Add a few items to the FAQ
* 1.7.0 Aug 12, 2019
  * Add support for setting generated image quality, either generally or
    specific to given formats.
  * Add support for spaces and other url-encoded characters in filenames
  * Documentation restructure - Moved it out of the wiki, into the `docs`
    folder.
  * Bugfix: Fallback image width will now be checked against source image width.
  * Bugfix: Minor fix to nomarkdown wrapper output
  * link_source will now target the base source image, rather than finding the
    biggest one.
  * Remove fastimage dependency, add addressable dependency.
  * Moderately significant refactoring and code cleanup
  * Decent set of tests added
* 1.6.0 Jul  2, 2019:
  * Missing Preset warning respects `data_dir` setting
  * Add `continue_on_missing` option
* 1.5.0 Jun 26, 2019:
  * better `{::nomarkdown}` necessity detection
  * allow user to override `{::nomarkdown}` autodetection
* 1.4.0 Jun 26, 2019:
  * Rename gem from `jekyll-picture-tag` to `jekyll_picture_tag`, allowing us to
    use rubygems again.
  * Add new output format: `naked_srcset`.
* 1.3.1 Jun 21, 2019: Bugfix
* 1.3.0 Jun  7, 2019:
  * Initial compatibility with Jekyll 4.0
  * bugfixes
  * change to generated image naming-- The first build after this update will be
    longer, and you might want to clear out your generated images.
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
* **1.0.0** Nov 27, 2018: Rewrite from the ground up. See the [migration guide]({{ site.baseurl
  }}/users/notes/migration_1).
* 0.2.2 Aug  2, 2013: Bugfixes
* 0.2.1 Jul 17, 2013: Refactor again, add Liquid parsing.
* 0.2.0 Jul 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.
* 0.1.1 Jul  5, 2013: Quick round of code improvements.
* 0.1.0 Jul  5, 2013: Initial release.
