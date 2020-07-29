---
---

# Installation

1. Add `jekyll_picture_tag` to your Gemfile in the `:jekyll_plugins` group.
  (Note that it's NOT `jekyll-picture-tag`):
    ```ruby
    # Gemfile

    gem 'jekyll'

    group :jekyll_plugins do
      gem 'jekyll_picture_tag', ~> '1'
    end
    ```
2. Run `$ bundle install`
3. See if you have ImageMagick with `$ convert --version`. You should see
   something like this:
  ```bash
  ~ $ convert --version
  Version: ImageMagick 7.0.8-14 Q16 x86_64 2018-10-31 https://imagemagick.org
  Copyright: © 1999-2018 ImageMagick Studio LLC License: https://imagemagick.org/script/license.php
  Features: Cipher DPC HDRI OpenMP Delegates (built-in): bzlib fontconfig freetype jng jp2 jpeg lcms
  lzma pangocairo png tiff webp xml zlib
  ```
  If you get a 'command not found' error, you'll need to install it. Most
  package managers know about ImageMagick, otherwise it can be found
  [here](https://imagemagick.org/script/download.php).

```note
  You need a 'webp' delegate if you want to generate webp files. Any image
  format you want to handle will require an appropriate delegate; You may have
  to install additional packages to accomplish this. Usually it's just named
  'webp'.
```

```warning
Cropping to an aspect ratio depends on ImageMagick 7+. Ubuntu, somewhat
annoyingly, only offers version 6 in its official repositories. This matters
even if you don't run Ubuntu, because many build & deployment services you might
use (including Netlify and Travis CI) do.
```

If you'd like to use both the cropping feature and such a service, or it's
inconvenient to install version 7 in your development environment, you will
likely want to build your site in a docker container. The Alpine Linux repos
include version 7, so you'll want an Alpine Linux based image rather than an
Ubuntu based one. Conveniently this includes the [offical Jekyll
image](https://hub.docker.com/r/jekyll/jekyll).

Once I work out how to actually do that, I'll add some guidance here.
