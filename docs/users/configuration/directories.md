---
sort: 1
---

# Directories

Define where JPT should look for source images, and where it should place
generated images.

## Source

*Format:* `source: (directory)`

*Example:* `source: images/`

*Default:* Jekyll site root.

Base directory for your source images, relative to the Jekyll site root. For
example, if set to `images/_fullsize`:

this tag: {% raw %} `{% picture enishte/portrait.jpg %}` {% endraw %} 
will use this path: `images/_fullsize/enishte/portrait.jpg`.

## Output

*Format:* `output: (directory)`

*Example:* `output: resized_images/`

*Default*: `generated/`

Save resized, reformatted images to this directory in your compiled site. The
`source` directory structure is maintained. Relative to your compiled site
directory, which means `_site/` unless you've changed it.
