---
sort: 5
---

# CDN 

Use for images that are hosted at a different domain or subdomain than the
Jekyll site root. Overrides `relative_url`. 

## URL

*Format:* `cdn_url: (url)`

*Example:* `cdn_url: https://cdn.example.com`

*Default*: none

## Environments

It's likely that if you're using a CDN, you may not want to use it in your local
development environment. This allows you to build a site with local images while
in development, and still push to a CDN when you build for production by
specifying a different 
[environment](https://jekyllrb.com/docs/configuration/environments/). 

*Format:* `cdn_environments: (array of strings)`

*Example:* `cdn_environments: ['production', 'staging']`

*Default*: `['production']`

**Note that the default jekyll environment is `development`**, meaning that if
you only set `cdn_url` and run `jekyll serve` or `jekyll build`, nothing will
change. Either run `JEKYLL_ENV=production bundle exec jekyll build`, or add
`development` to this setting.
