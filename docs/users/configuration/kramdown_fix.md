---
sort: 6
---

# Kramdown Fix

*Format:* `nomarkdown: (true|false)`

*Example:* `nomarkdown: false`

*Default:* `true`

Whether or not to surround j-p-t's output with a
`{::nomarkdown}..{:/nomarkdown}` block when called from within a markdown file.
When false, JPT will never add the wrapper. When true, JPT will add it only when
it believes it's necessary, though it's not 100% accurate at making this
determination.

This setting is overridden by the same setting in a preset. See [this note]({{
site.baseurl }}/users/notes/kramdown_bug) for more detailed information. 
