```
---
layout: post
title: Tag examples
image: img.jpg
---
```

- Standard image, default preset, with alt text:

  `{% picture portrait.jpg --alt An unsual picture %}`

- Select the `gallery` `markup_preset` (which you must define!):

  `{% picture gallery portrait.jpg %} `

- Specify html attributes:

  `{% picture portrait.jpg --picture class="some classes" data-downloadable="true" %}`

- Provide multiple source images for different screen sizes: (note that you must
define the mobile `media_preset`):

  `{% picture portrait.jpg mobile: portrait-cropped.jpg %}`

- Wrap picture in a link to something: 

  `{% picture portrait.jpg --link /profile.html %}`

- Use liquid variables:

  `{% picture {{ post.image }} %}`

- Line breaks and indentation are fine:

```
  {% 
    picture 
      gallery
      portrait.jpg
      mobile: portrait-cropped.jpg
      --picture class="portrait" data-downloadable="true"
      --img data-awesomeness="11"
      --alt Ugly Mug
  %}
```
