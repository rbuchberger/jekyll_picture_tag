# Extra {::nomarkdown} tags or mangled HTML?

## TLDR up front 

There's a bug involving `<picture>` tags wrapped in `<a>` tags which is not in
my power to fix.

* If you're getting extra `{::nomarkdown}` tags floating around your images, add `nomarkdown:
  false` to either the relevant preset or under `picture` in `_config.yml`. 

* If you're getting mangled HTML when trying to wrap images with anchor tags, add `nomarkdown:
  true` to the preset. 

## What's going on here:

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

## The fix:

By default, JPT will add a `{::nomarkdown}` tag if all of the following are true:
* It thinks it's called from a markdown page
* The image will be wrapped in an anchor tag (i.e. `link_source_image:` or a `--link` parameter)
* This behavior hasn't been explicitly disabled. 

You can disable nomarkdown tags globally by setting `nomarkdown: false` under the `picture:` key in
`_config.yml`.

You can enable or disable markdown tags per preset by adding `nomarkdown: true|false` to them.
**This setting overrides everything else, both JPT autodetection and the global setting.**
