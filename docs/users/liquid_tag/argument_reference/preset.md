---
sort: 1
---

# Preset

Select a [preset]({{ site.baseurl }}/users/presets), or omit to
use the `default` preset. A preset is a collection of settings which determines
nearly everything about JPT's output, from the image formats used to the exact
format your final HTML will take. Think of it like a recipe or a blueprint; JPT
will take the information provided in the liquid tag, combine it with the
settings written in the preset, and use it to craft your images and markup.

If the `preset` is omitted then default settings will be used, in the simplest
case resulting in an `<img>` tag containing a srcset pointing to your newly
generated images. You are free to override the `default` preset and define
your own settings, giving full flexibility in what JPT will create.
