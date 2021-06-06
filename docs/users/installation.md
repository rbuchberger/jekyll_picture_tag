---
sort: 1
---

# Installation

1. Add `jekyll_picture_tag` to your Gemfile in the `:jekyll_plugins` group.

    ```note
    It's NOT `jekyll-picture-tag`.
    ```

    ```ruby
    # Gemfile

    gem 'jekyll', '~> 4.0'

    group :jekyll_plugins do
      # (other jekyll plugins)
      gem 'jekyll_picture_tag', '~> 2.0'
    end
    ```

2. Run `$ bundle install`
3. Install `libvips`. Most package managers know about it, otherwise it can be found
   [here](https://libvips.github.io/libvips/install.html).
4. Install libvips dependencies for all image formats you will use, such as `libpng`, `libwebp`,
   `libjpeg`, and `libheif` (for avif). Note that if you use a deployment or CI service, these
   dependencies will be required there as well.
5. Optional: Install `ImageMagick` for additional image formats. If vips runs into an image format
   it can't handle (jp2 on my particular installation), JPT will instruct it to try ImageMagick
   instead.
