---
sort: 4
---

# Alternate images

  _Format:_ `(media_query): (filename) [crop] [gravity] (...)`

  _Example:_ `tablet: img_cropped.jpg mobile: img_cropped_more.jpg`

Optionally specify any number of alternate base images for given
[media_queries]({{ site.baseurl }}/users/presets/media_queries). This is called
[art direction](http://usecases.responsiveimages.org/#art-direction), and is one
of JPT's strongest features.

Give your images in order of ascending specificity (The first image is the
most general). They will be provided to the browser in reverse order, and it
will select the first one with an applicable media query.
