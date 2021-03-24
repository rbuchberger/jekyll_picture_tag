---
sort: 2
---

# Tag Usage

This section describes how to use JPT's liquid tag ({% raw %} `{% picture (...)
%}` {% endraw %}); what options it takes and what kind of information you can pass
through it to influence the the final HTML and generated images.

## Format

{% raw %}
`{% picture [preset] (image) [crop] [alternate images & crops] [attributes] %}`
{% endraw %}

The only required argument is the base image. Line breaks and extra spaces are
fine, and you can use liquid variables anywhere.

* `preset` - Select a recipe/blueprint from the ones you have defined in
  `presets`. Will use `default` if not specified.

* `(image)` - required.

* `crop` - Aspect ratio & keep settings.

* `alternate images & crops` - Art Direction; show different images on different
  devices. Give in order of ascending specificity.

* `attributes` - Add css classes, data-attributes, or wrap the whole thing in an
  anchor tag.
