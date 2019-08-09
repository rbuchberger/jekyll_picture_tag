These are my notes from writing the integration tests. Might be useful later so
I'll leave it in the repo.

## Jekyll inputs:

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

## Calls to jekyll/liquid: 

* Liquid::Template.parse(params).render(context)
* Liquid::Template.register_tag('picture', PictureTag::Picture)
