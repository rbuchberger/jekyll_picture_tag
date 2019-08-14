---
---
# Release History

* 1.7.0 Aug 12, 2019
  * Add support for setting generated image quality, either generally or specific to given
    formats.
  * Add support for spaces and other url-encoded characters in filenames
  * Documentation restructure - Moved it out of the wiki, into the `docs` folder.
  * Bugfix: Fallback image width will now be checked against source image width.
  * Bugfix: Minor fix to nomarkdown wrapper output
  * link_source will now target the base source image, rather than finding the biggest one.
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
* **1.0.0** Nov 27, 2018: Rewrite from the ground up. See the [migration guide](/migration).
* 0.2.2 Aug  2, 2013: Bugfixes
* 0.2.1 Jul 17, 2013: Refactor again, add Liquid parsing.
* 0.2.0 Jul 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.
* 0.1.1 Jul  5, 2013: Quick round of code improvements.
* 0.1.0 Jul  5, 2013: Initial release.
