---
sort: 1
---
# Global Configuration

**All configuration is optional**. If you are happy with the defaults, you don't
have to touch a single yml file.

Global settings are stored under the `picture:` key in `/_config.yml`.

**Example:**

```yml
# _config.yml

(...)

picture:
  source: "assets/images/fullsize"
  output: "assets/images/generated"
  suppress_warnings: true
  (...)

(...)
```

## Reference

{% include list.liquid %}
