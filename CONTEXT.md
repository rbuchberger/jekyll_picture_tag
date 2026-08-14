# Jekyll Picture Tag

A Jekyll plugin that turns a Liquid `{% picture %}` tag into responsive image
markup, generating resized and reformatted source images along the way.

This document is a glossary. It defines what the project's terms mean, not how
they are implemented.

## Settings

Four distinct things get called "configuration" in conversation. They have
different sources, different lifetimes, and different compatibility guarantees.

**Jekyll Config**:
The site's entire `_config.yml`, including keys owned by Jekyll and by other
plugins. JPT reads a handful of these (`destination`, `baseurl`, `keep_files`)
in addition to its own.
_Avoid_: config, site config

**Picture Config**:
The `picture:` subtree of `_config.yml`. Build-wide settings that describe the
site's environment rather than any particular image: source and output
directories, CDN, URL style, whether JPT is disabled.
_Avoid_: config, global config, pconfig

**Preset**:
A named bundle of settings describing how to build one family of images —
formats, widths, quality, markup format, cropping. Defined under `presets:` in
`_data/picture.yml`, selected by name as the first argument to the Liquid tag.
Presets are per-tag; Picture Config is per-site.
_Avoid_: profile, template

**Params**:
The arguments given to a single Liquid tag: preset name, source image
filenames, media queries, crop and keep settings, and HTML attributes. The
only setting source that varies between two tags on the same page.
_Avoid_: arguments, options

## Setting resolution

**Sourcing**:
Reading a setting document from its origin (`_config.yml`, `_data/picture.yml`)
and deep merging it over the built-in defaults, so that setting one key of a
nested setting keeps the defaults for its siblings. Produces a raw document;
asserts nothing about its contents.

**Validation**:
Deciding whether a sourced document is acceptable, and reporting precisely why
if it isn't. Validation never changes a value.

**Coercion**:
Normalizing a valid-but-flexible input into the single canonical form the rest
of the code consumes — a bare string into a one-element list, `center` into
`centre`, a markup name into a class.
_Avoid_: casting, parsing

**Resolution**:
Answering "what is the value of this setting *here*" when the answer depends on
runtime context rather than on the document alone. Distinct from coercion: the
inputs are not part of the setting document. Three kinds exist — by media query
(`media_widths`), by image format (`format_quality`), and by Jekyll
environment.
_Avoid_: lookup, evaluation

**Environment Expression**:
A setting whose value is a boolean, a Jekyll environment name, or a list of
environment names, resolving to a boolean against the current environment.
Used by `cdn_environments`, `disabled`, `fast_build`, and others.

## Output

**Markup Format**:
The shape of the HTML a tag emits — `picture`, `img`, `direct_url`,
`naked_srcset`, and the `data_*` lazy-loading variants. Selected by a preset's
`markup:` key. `auto` picks between `picture` and `img` based on how many
srcsets the preset produces.
_Avoid_: output format, template

**Srcset**:
One `srcset` attribute's worth of generated images: a single image format at a
range of widths, or at a range of pixel ratios.

**Source Image**:
A file the user committed to their site, named in a tag. Never modified.

**Generated Image**:
A file JPT writes into the output directory — one source image at one width in
one format. Content-addressed by name, so an unchanged source at unchanged
settings is never rebuilt.
_Avoid_: output image, resized image, derivative
