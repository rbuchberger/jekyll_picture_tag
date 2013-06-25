# liquid-picturefill

## Goals

- Full implementation of picturefill with automatic image generation
- Short syntax to avoid verbosity of picturefill markup
- Full options available in cascade

#### Requirements

Impliment all picturefill options.  
Starting with sensible defaults from minimal input. Cascading with more specific input.  
YAML settings file.

- main tag (picture) 
    - class, 
    - id, 
    - alt, 
    - [other attributes]
    - fallback image
- source 
    - source
    - media
    - source dimensions
    - source res

## Questions

- Liquid use keyed arguments?
- Does a return within a tag break parsing?

## References

#### Liquid:

- http://octopress.org/docs/plugins/image-tag/
- http://wiki.shopify.com/Img_tag
- https://gist.github.com/vanto/1455726
- http://octopress.org/docs/plugins/blockquote/
- http://www.pztrick.com/blog/2012/06/26/jekyll-fancyimage-tag/

I like this attribute syntax: https://github.com/stereobooster/jekyll_oembed
If we can use variable arguments, that would be ideal.

#### Plugins that use yaml config:

- https://github.com/matthewowen/jekyll-json
- https://github.com/krazykylep/Jekyll-Sort

#### Plugins that use arguments inside content block:

- https://github.com/moshen/jekyll-asset_bundler

#### Minimagik

- https://github.com/minimagick/minimagick
- https://github.com/mrdanadams/jekyll-thumbnailer

#### Picture

- https://github.com/responsiveimagescg
- https://github.com/scottjehl/picturefill
- https://twitter.com/respimg/status/342749885872869377

#### Tutorials

- https://www.chiliproject.org/projects/chiliproject/wiki/Liquid_for_Developers
- https://groups.google.com/forum/#!topic/liquid-templates/OgJ95Zs0jRc
- http://stackoverflow.com/questions/7666236/how-to-pass-a-variable-into-a-custom-tag-in-liquid
- http://robots.thoughtbot.com/post/159806314/custom-tags-in-liquid


## Spec

#### YAML Example:

```yml
plugin_name:
  source_dir: "path/to/source_dir"
  output_dir: "path/to/output_dir"
  ppi: [1, 1.3, 3]
  default:
    attr:
      class: "class"
      data-something: "data"
    media: “(min-width: 30em)”
      width: “500”
      height: “300”
      ...
  gallery:
    media: “(min-width: 25em)”
      width: “100”
      height: “100”
      ...
```

#### Filter

Short Version:

`{% picture path/to/image.jpg [ alt: “description of the image” ] [ preset ] %}`

Full version:

`{% picture path/to/image.jpg [alt: “”] [attr: class=””, data-something=””]`  
`[ preset: xxx ] [2: path/to/2/src]  %}`

```
{% picture 
   path/to/source/image.jpg

   // Any attribute
   alt="value" 
   id="value"
   class="value"

   preset: path/to/preset.yml
   preset-target: path/to/alt/source
   preset-target-two: path/to/alt/source
%}
```
