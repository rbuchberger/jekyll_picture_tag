---
sort: 5
---

# Cropping

**Check the warning in the 
[installation guide]({{ site.baseurl }}/users/installation) 
before using this feature.**

## Crop & Media Crop

_Format:_

```yaml
    crop: (geometery)
    media_crop:
      (media_preset): (geometry)
      (media_preset): (geometry)
      (...)
```

_Example:_

```yaml
    crop: 16:9
    media_crop:
      tablet: 3:2
      mobile: 1:1
```

Crop geometry, given either generally or for specific media presets. The
hierarchy is: `tag argument` > `media_crop:` > `crop:`.

This setting accepts the same arguments as the `crop geometry` 
[tag parameter]({{ site.baseurl }}/users/liquid_tag/argument_reference/crop).

## Gravity & Media Gravity

```yaml
    gravity: (gravity)
    media_gravity:
      (media_preset): (gravity)
      (media_preset): (gravity)
      (...)
```

_Example:_

```yaml
    gravity: north
    media_gravity:
      tablet: east
      mobile: southwest
```

Crop gravity, given either generally or for specific media presets. The hierarchy is:
`tag argument` > `media_gravity:` > `gravity:` > `center` (default).

This setting accepts the same arguments as the `crop gravity` 
[tag parameter]({{ site.baseurl }}/users/liquid_tag/argument_reference/crop).
