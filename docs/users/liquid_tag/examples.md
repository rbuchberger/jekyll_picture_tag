---
---
# Examples

{% raw %}

  * Basic form, will use the preset named 'default': 
  ```
  {% picture example.jpg %}
  ```

  * Include alt text:
  ```
  {% picture example.jpg --alt Alt Text %}
  ```

  * Select a `preset` (defined in `_data/picture.yml`:
  ```
  {% picture my_preset example.jpg %}
  ```

  * Show different images on different devices. (Note that `mobile` must be set
  to some media query under `media_queries:` in `_data/picture.yml`.
  ```
  {% picture example.jpg mobile: example_cropped.jpg %}
  ```

  * Use liquid variables:
  ```
  {% picture "{{ page.some_liquid_variable }}" %}
  ```

  * Select the blog_index preset, use liquid variables, and wrap the image in an
  anchor tag (link):
  ```
  {% picture blog_index "{{ post.image }}" --link {{ post.url }} %}
  ```

   **Note:** If the image path is coming from a liquid variable then you should guard against spaces
   by wrapping the inner tag in quotes, as in the previous examples.

  * Add arbitrary HTML attributes:
  ```
  {% picture example.jpg --picture class="some classes" --img id="example" %}
  ```

  * Crop to a 16:9 aspect ratio (Will keep the part of the image "most likely to
    draw human attention"):
  ```
  {% picture example.jpg 16:9 %}
  ```

  * Crop to a 1:1 aspect ratio, keeping the middle, with alt text:
  ```
  {% picture thumbnail example.jpg 1:1 center --alt Example Image %}
  ```

  * Crop the same image multiple times:
  ```
  {% picture example.jpg 16:9 tablet: example.jpg 4:3 mobile: example.jpg 1:1 %}
  ```

  * Use filenames with spaces:
  ```
  {% picture "some example.jpg" mobile: other\ example.jpg %}
  ```

  * Use line breaks to make a complicated tag manageable:
  ```
    {% 
      picture
      hero
      example.jpg 16:9 entropy
      tablet: example2.jpg 3:2
      mobile: example3.jpg 1:1
      --alt Happy Puppy
      --picture class="hero"
      --link /
    %}
  ```
{% endraw %}
