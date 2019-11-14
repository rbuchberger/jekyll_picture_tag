---
---
# Notes and FAQ

* #### Github Pages?

  Github Pages only allows a very short whitelist of plugins, which sadly does not include JPT. You
  can either run it locally, then commit and push the generated files (rather than the source
  files), or just host it some other way. I recommend Netlify.

* #### HTML attributes

  Jekyll Picture Tag has comprehensive attribute support for all generated HTML. You can add
  attributes both through the [liquid tag]({{ site.baseurl }}/usage), and the [preset]({{
  site.baseurl }}/presets) (scroll down a bit).

* ### Input checking

  Jekyll Picture Tag is very trusting. It doesn't do much checking of your inputs, and it does not
  fail gracefully if you for example pass it a string when it expects an array. It's on the to-do
  list, but for now if you get cryptic errors then double-check your settings and tag arguments.

* ### Git LFS

  I'm Putting this here because it bit me: If you want to use git LFS, make sure that your hosting
  provider makes those images available during the build process.  Netlify, for example, does not.
  You won't find this out until you have gone through the entire migration process and try to deploy
  for the first time.


* #### Extra {::nomarkdown} tags or mangled HTML?

  **TLDR up front:** There's a bug involving `<picture>` tags wrapped in `<a>` tags which is not in my
  power to fix.

  * If you're getting extra `{::nomarkdown}` tags floating around your images, add `nomarkdown:
    false` to either the relevant preset or under `picture` in `_config.yml`. 

  * If you're getting mangled HTML when trying to wrap images with anchor tags, add `nomarkdown:
    true` to the preset. 
  
  **What's going on here:**

  Kramdown is Jekyll's default markdown parser. Kramdown gets grumpy when you give it a block level
  element (such as a `<picture>`) surrounded by a span level element (such as an `<a>`), and horribly
  mangles it. The fix for this is to tell Kramdown to chill with a `{::nomarkdown}..{:/nomarkdown}`
  wrapper.

  Jekyll Picture Tag can be called from many different places: a markdown file, an HTML file, an HTML
  layout for a markdown file, and an HTML include, to name a few. JPT tries its best to determine
  whether its output will be parsed by Kramdown or not, but Jekyll itself doesn't make this
  particularly easy which results in some false positives. (The one I'm most aware of is when a
  markdown file uses an HTML layout which includes a picture tag.) 

  Unfortunately, I don't see an easy way to fix this. We've gotten this far mostly by trial and error.
  I'll continue to work on improving the autodetection, but you can override this behavior explicitly. 

  **The fix:**

  By default, JPT will add a `{::nomarkdown}` tag if all of the following are true:
  * It thinks it's called from a markdown page
  * The image will be wrapped in an anchor tag (i.e. `link_source_image:` or a `--link` parameter)
  * This behavior hasn't been explicitly disabled. 

  You can disable nomarkdown tags globally by setting `nomarkdown: false` under the `picture:` key in
  `_config.yml`.

  You can enable or disable markdown tags per preset by adding `nomarkdown: true|false` to them.
  **This setting overrides everything else, both JPT autodetection and the global setting.**

* ### Managing Generated Images

  Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a
  smart caching system to speed up site compilation, and re-uses images as much as possible.
  Filenames take the following format:

  `(original name without extension)-(width)-(source hash).(filetype)`

  Source hash is the first 5 characters of an md5 checksum of the source image.

  Try to use a base image that is larger than the largest resized image you need. Jekyll Picture Tag
  will warn you if a base image is too small, and won't upscale images.

  By specifying a `source` directory that is ignored by Jekyll you can prevent huge base images from
  being copied to the compiled site. For example, `source: assets/images/_fullsize` and `output:
  generated` will result in a compiled site that contains resized images but not the originals. Note
  that this will break source image linking, if you wish to enable it. (Can't link to images that
  aren't public!)

  The `output` directory is never deleted by Jekyll. You may want to empty it once in awhile, to
  clear out unused images. 
