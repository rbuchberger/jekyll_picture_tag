# Test cases

- Basic test case, default settings, missing images
- basic test case, default settings, existing images
- multiple source images
- at least one case for every output format, plus additional cases as necessary
- pixel ratio srcset
- source image linking
- regular linking

- html attributes (all, including alt text) from preset
- html attributes (all, including alt text) from tag
- sizes attribute
- anchor tag wrapper
- nomarkdown wrapper

- suppress warnings
- continue on missing
- relative urls
- cdn url
- cdn environments

- media widths
- look through issue history
- no persistence between tag args

# Jekyll inputs:

* context
  - .environments.first['jekyll']['environment']
  - .registers
    - :site
      - .config
        - 'keep_files'
        - 'picture'
          - (jpt global settings)
        - 'data_dir'
        - 'url'
        - 'baseurl'
      - .source (jekyll source dir)
      - .dest (jekyll dest dir)
      - .data
        - 'picture'
          - 'media_presets'
          - 'markup_presets'
    - :page
      - 'name'
      - 'ext'
* params
  - whatever's in the liquid tag, minus the starting 'picture'

# Calls to jekyll/liquid: 

* Liquid::Template.parse(params).render(context)
* Liquid::Template.register_tag('picture', PictureTag::Picture)
