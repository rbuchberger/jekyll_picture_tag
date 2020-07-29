---
---
# Release History
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
* **1.0.0** Nov 27, 2018: Rewrite from the ground up. See the 
* [migration guide]({{ site.baseurl }}/users/notes/migration).
* 0.2.2 Aug  2, 2013: Bugfixes
* 0.2.1 Jul 17, 2013: Refactor again, add Liquid parsing.
* 0.2.0 Jul 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.
* 0.1.1 Jul  5, 2013: Quick round of code improvements.
* 0.1.0 Jul  5, 2013: Initial release.
