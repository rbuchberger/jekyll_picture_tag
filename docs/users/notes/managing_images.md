# Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the
site. It uses a caching system to speed up site compilation, and re-uses images
as much as possible. Filenames take the following format:

`(original name without extension)-(width)-(id-string).(filetype)`

Try to use a base image that is larger than the largest resized image you need.
Jekyll Picture Tag will warn you if a base image is too small, and won't upscale
images.

By specifying a `source` directory that is ignored by Jekyll you can prevent
huge base images from being copied to the compiled site. For example, `source:
assets/images/_fullsize` and `output: generated` will result in a compiled site
that contains resized images but not the originals. Note that this will break
source image linking, if you wish to enable it. (Can't link to images that
aren't public!)

The `output` directory is never deleted by Jekyll. You may want to empty it once
in awhile, to clear out unused images.
