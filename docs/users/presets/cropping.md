---
sort: 7
---

# Cropping

## Crop & Media Crop

_Format:_

```yaml
    crop: (aspect ratio)
    media_crop:
      (media_preset): (aspect ratio)
      (media_preset): (aspect ratio)
      (...)
```

_Example:_

```yaml
    crop: '16:9'
    media_crop:
      tablet: '3:2'
      mobile: '1:1'
```

Crop aspect ratio, given either generally or for specific media presets. The
hierarchy is: `tag argument` > `media_crop:` > `crop:`.

This setting accepts the same arguments as the `crop` 
[tag parameter]({{ site.baseurl }}/users/liquid_tag/argument_reference/crop).

## Keep & Media Keep

```yaml
    keep: (measure)
    media_keep:
      (media_preset): (measure)
      (media_preset): (measure)
      (...)
```

_Example:_

```yaml
    keep: attention
    media_gravity:
      tablet: entropy
      mobile: center
```

Which part of the image to keep when cropping, given either generally or for specific media presets.
The hierarchy is: `tag argument` > `media_keep:` > `keep:` > `attention` (default).

This setting accepts the same arguments as the `keep` [tag parameter]({{ site.baseurl
}}/users/liquid_tag/argument_reference/crop):
* `center` or `centre`
* `attention`
* `entropy`
