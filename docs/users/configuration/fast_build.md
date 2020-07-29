---
sort: 4
---

# Fast Build

*Format:* `fast_build: (boolean|environment|environments)`

*Examples:* 

  - `fast_build: true`

  - `fast_build: development`

  - `fast_build: [development, staging]`

*Default:* `false`

*Might* make your builds faster (depending on hardware and how many images you
have) by making a tradeoff: assuming that the filename alone is enough to
uniquely identify a source image. This doesn't speed up image generation, just
detection of whether or not it's necessary.

Ordinarily, JPT computes an MD5 hash for every source image, every site build.
This ensures that if you replace one image with another, but keep the filename
the same, JPT will correctly generate images for the new file. Enable this
setting to skip MD5 hash checking and just assume that if the filename, format,
and width match then it's the right one.
