# Test cases

## presets
- html attributes (all, including alt text and parent) from preset
- pixel ratio srcset
- source image linking
- sizes attribute
- media widths
- output formats
  * auto
  * img
  * picture
  * data_auto
  * data_img
  * data_picture
    - noscript tag
  * naked_srcset
  * direct_url

## configuration

- nomarkdown wrapper
- suppress warnings
- continue on missing
- relative urls
- cdn url
- cdn environments

# other

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
