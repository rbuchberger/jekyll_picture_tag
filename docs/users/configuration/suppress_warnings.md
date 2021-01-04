---
sort: 3
---

# Suppress Warnings

*Format:* `suppress_warnings: (true|false)`

*Example:* `suppress_warnings: true`

*Default*: `false`

Jekyll Picture Tag will warn you in a few different scenarios, such as when your
base image is smaller than one of the sizes in your preset. (Note that Jekyll
Picture Tag will never resize an image to be larger than its source). Set this
value to `true`, and these warnings will not be shown.
