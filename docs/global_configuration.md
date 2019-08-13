{% raw %}
# Global Configuration

**All configuration is optional**. If you are happy with the defaults, you don't have to touch a
single yaml file.

Global settings are stored under the `picture:` key in `/_config.yml`.

**Example config:**

```yml
picture:
  source: "assets/images/fullsize"
  output: "assets/images/generated"
```

* **Source Image Directory**

  *Format:* `source: (directory)`

  *Example:* `source: images/`

  *Default:* Jekyll site root.

  To make writing tags easier you can specify a source directory for your assets. Base images in the
  tag will be relative to the `source` directory, which is relative to the Jekyll site root.

  For example, if `source` is set to `assets/images/_fullsize`, the tag
  `{% picture enishte/portrait.jpg --alt An unsual picture %}` will look for a file at
  `assets/images/_fullsize/enishte/portrait.jpg`.

* **Destination Image Directory**

    *Format:* `output: (directory)`

    *Example:* `output: resized_images/`

    *Default*: `generated/`

  Jekyll Picture Tag saves resized, reformatted images to the `output` directory in your compiled
  site. The organization of your `source` directory is maintained.

  This setting is relative to your compiled site, which means `_site` unless you've changed it.

* **Suppress Warnings**

    *Format:* `suppress_warnings: (true|false)`

    *Example:* `suppress_warnings: true`

    *Default*: `false`

  Jekyll Picture Tag will warn you in a few different scenarios, such as when your base image is
  smaller than one of the sizes in your preset. (Note that Jekyll Picture Tag will never resize an
  image to be larger than its source). Set this value to `true`, and these warnings will not be shown.

* **Continue build with missing source images**

    *Format:* `ignore_missing_images: (boolean|environment name|array of environments)`

    *Example:* `ignore_missing_images: [development, testing]`

    *Default:* `false`

  Normally, JPT will raise an error if a source image is missing, causing the entire site build to fail. This setting allows you to bypass this behavior and continue the build, either for certain build environments or all the time. I highly encourage you to set this to `development`, and set the jekyll build environment to `production` when you build for production so you don't shoot yourself in the foot (publish a site with broken images). You can read more about Jekyll environments [here](https://jekyllrb.com/docs/configuration/environments/).
  
* **Use Relative Urls**

    *Format:* `relative_url: (true|false)`

    *Example:* `relative_url: false`

    *Default*: `true`

  Whether to use relative (`/generated/test(...).jpg`) or absolute
  (`https://example.com/generated/test(...).jpg`) urls in your src and srcset attributes.

* **Use a CDN Url**

    *Format:* `cdn_url: (url)`

    *Example:* `cdn_url: https://cdn.example.com`

    *Default*: none

    Use for images that are hosted at a different domain or subdomain than the Jekyll site root. Overrides
    `relative_url`. Keep reading, the next option is important.

* **CDN build environments**

    *Format:* `cdn_environments: (array of strings)`

    *Example:* `cdn_environments: ['production', 'staging']`

    *Default*: `['production']`

    It's likely that if you're using a CDN, you may not want to use it in your local development environment. This
    allows you to build a site with local images while in development, and still push to a CDN when you build for
    production by specifying a different [environment](https://jekyllrb.com/docs/configuration/environments/). 

    **Note that the default jekyll environment is `development`**, meaning that if you only set `cdn_url` and run
    `jekyll serve` or `jekyll build`, nothing will change. You'll either need to run `JEKYLL_ENV=production bundle exec
    jekyll build`, or add `development` to this setting.

* **Kramdown nomarkdown fix**

  *Format:* `nomarkdown: (true|false)`

  *Example:* `nomarkdown: false`

  *Default*: `true`

  Whether or not to surround j-p-t's output with a `{::nomarkdown}..{:/nomarkdown}` block when called
  from within a markdown file. 

  This setting is overridden by the same setting in a preset. See [this wiki page](https://github.com/rbuchberger/jekyll_picture_tag/wiki/Extra-%7B::nomarkdown%7D-tags-or-mangled-html%3F) for more detailed information. 

{% endraw %}
