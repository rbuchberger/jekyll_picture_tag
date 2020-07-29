---
sort: 1
---

# Standard HTML

- **`picture`** - `<picture>` element surrounding a `<source>` tag for each required srcset, and a
  fallback `<img>`:

  ```html
    <picture> 
      <source srcset="..." sizes="..." media="..." type="...">
      <source srcset="..." sizes="..." media="..." type="...">
      (...)
      <img src="...">
    </picture
  ```

- **`img`** - a single `<img>` tag with a `srcset` entry:

  ```html
  <img src="..." srcset="..." sizes="..." alt="..." width="..." height="...">
  ```

- **`auto`** - Supply an img tag when you have only one srcset, otherwise supply a picture tag.
