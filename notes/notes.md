# Liquid Picture

## Goals

- Full implementation of picturefill with automatic image generation
- Short syntax to avoid verbosity of picturefill markup
- Start with sensible defaults from minimal input. Cascading with more specific input.  

## References

#### Simple image tag:

- http://octopress.org/docs/plugins/image-tag/

#### Read Jekyll config.yml:

Justin, looks like Jekyll has a built in way to get the site's config.yml. This handles some edge cases for us like merging multiple configuration files, too.

- https://github.com/octopress/config-tag/blob/master/plugins/config_tag.rb#L17
- https://github.com/matthodan/jekyll-asset-pipeline/blob/80955195e16d5fc8712fba6bbc16a8a53e2491f9/lib/jekyll_asset_pipeline/extensions/liquid/liquid_block_extensions.rb#L13-L15
- https://github.com/matthewowen/jekyll-json/blob/master/jekyll_json.rb
- https://github.com/krazykylep/Jekyll-Sort/blob/master/jekyll_sort.rb#L10-L15

#### Minimagic create images:

- https://github.com/minimagick/minimagick
- https://gist.github.com/pztrick/2963361#file-fancyimage_tag-rb
- https://github.com/mrdanadams/jekyll-thumbnailer

#### Picture

- https://github.com/scottjehl/picturefill
- https://github.com/responsiveimagescg
- https://twitter.com/respimg/status/342749885872869377

## Spec

#### YAML Example

See [_config.yml](_config.yml)

#### tag

Short Version:

{% picture path/to/img.jpg alt="A Picture" preset: gallery %}

Full version:

```
{% picture path/to/img.jpg attribute="value" preset: preset_name media_1: path/to/alt/img.jpg %}

{% picture 
   path/to/source/image.jpg

   // Any attribute
   alt="value" 
   id="value"
   class="value"

   preset: path/to/preset.yml
   
   media_1: path/to/alt/img.jpg
   media_2: path/to/alt/img.jpg
%}
```
