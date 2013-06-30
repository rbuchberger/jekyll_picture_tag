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

```
{% picture [preset_name] path/to/img.jpg [media_1:path/to/alt/img.jpg] [attribute="value"] %}

{% picture 
  
  Full damn regex: 
  
  ((?<preset>[^\s.:]+)\s+)?(?<img_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source>((source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<attr>[\s\S]+)?$
    
  0 or 1 yml word without dot, space, .ext
  
  path with .ext
    separate path, basename ext
  
  0 or more source_*: path with .ext
    separate path, basename ext
    use string#scan to return a map of source_key, img_Path 
    http://stackoverflow.com/questions/4692437/regex-with-named-capture-groups-getting-all-matches-in-ruby
  
  everything else to end of string
    
    (?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s+
    
    separate alt="value"
    strip newlines, reduce whitespace to single spaces
    "some text\nandsomemore".gsub("\n",'')
    
    regex out into map:
    
    (word)(="(capture to)")?\s 
    
    http://stackoverflow.com/questions/13040585/split-string-by-spaces-properly-accounting-for-quotes-and-backslashes-ruby
    
    input.scan(/(?:"(?:\\.|[^"])*"|[^" ])+/)\\\\
    
    http://www.ruby-forum.com/topic/146473
    
  
%}
```

### Liquid/Ruby

Liquid `render(context)` 

- `context['page']` returns an object with page settings and yml
- `context.registers[:site].config` returns an object with global config and settings in it

### Minimagic

Huh, insanely easy for straight resize:

```
# Resize and write the thumbnail image, if it doesn't exist yet
if not File.exists?(thumb_path)
  thumb = MiniMagick::Image.open(image_path)
  thumb.resize(@dimensions)
  thumb.write(thumb_path)
end
```
Need to check how scale/crop works.
