---
sort: 2
---

# URLs

## Relative or Absolute

*Format:* `relative_url: (true|false)`

*Example:* `relative_url: false`

*Default*: `true`

Whether to use relative (`/generated/test(...).jpg`) or absolute
(`https://example.com/generated/test(...).jpg`) urls in your src and srcset attributes.

## Baseurl Key

*Format:* `baseurl_key: (string)`

*Example:* `baseurl_key: baseurl_root`

*Default*: `baseurl`

Some plugins, such as
[jekyll-multiple-languages-plugin](https://github.com/kurtsson/jekyll-multiple-languages-plugin),
work by modifying the standard `baseurl` setting, which can break JPT's images. It offers a new
setting, `baseurl_root`, which serves as the original `baseurl` setting without a language prefix.
Using `baseurl_key`, you can direct JPT to use that setting instead.

## Ignore Baseurl

*Format:* `ignore_baseurl: (true|false)`

*Example:* `ignore_baseurl: true`

*Default*: `false`

Depending on your other plugins and configuration, it may be useful for JPT to ignore the baseurl
setting entirely.

## CDN URL

Use for images that are hosted at a different domain or subdomain than the Jekyll site root.
Overrides `relative_url`. 

*Format:* `cdn_url: (url)`

*Example:* `cdn_url: https://cdn.example.com`

*Default*: none

## CDN Environments

It's likely that if you're using a CDN, you may not want to use it in your local development
environment. This allows you to build a site with local images while in development, and still push
to a CDN when you build for production by specifying a different
[environment](https://jekyllrb.com/docs/configuration/environments/). 

*Format:* `cdn_environments: (array of strings)`

*Example:* `cdn_environments: ['production', 'staging']`

*Default*: `['production']`

**Note that the default jekyll environment is `development`**, meaning that if you only set
`cdn_url` and run `jekyll serve` or `jekyll build`, nothing will change. Either run
`JEKYLL_ENV=production bundle exec jekyll build`, or add `development` to this setting.
