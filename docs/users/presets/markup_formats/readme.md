---
sort: 1
---

# Markup Formats

Define what format the generated text will take. Select one by setting
`markup:` in the relevant [preset]({{ site.baseurl }}/users/presets).

_Format:_ `markup: (setting)`

_Default_: `auto`


Example:

```yml
# /_data/picture.yml

markup_presets:
  my_preset:
    markup: data_auto
```

## Valid options:

### Standard HTML:
- `auto` - default
- `picture`
- `img`

### Javascript Friendly:
- `data_auto`
- `data_picture`
- `data_img`

### Fragments:
- `direct_url`
- `naked_srcset`

## Reference:

{% include list.liquid %}
