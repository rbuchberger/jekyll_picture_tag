---
sort: 4
---

# Ignore Missing Source Images

*Format:* `ignore_missing_images: (boolean|environment|environments)`

*Examples:* 
  - `ignore_missing_images: true`
  - `ignore_missing_images: development`
  - `ignore_missing_images: [development, testing]`

*Default:* `false`

Normally, JPT will raise an error if a source image is missing, causing the
entire site build to fail. This setting allows you to bypass this behavior and
continue the build, either for certain build environments or all the time. 

I highly encourage you to set this to `development`, and set the Jekyll build
environment to `production` when you build for production so you don't shoot
yourself in the foot. You can read more about Jekyll environments
[here](https://jekyllrb.com/docs/configuration/environments/).
