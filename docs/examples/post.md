---
layout: post
title: Tag examples
---

{% picture portrait.jpg --alt An unsual picture %}

What was the narrative that this representation was meant to embellish and complete? As I regarded
the work, I slowly sensed that the underlying tale was the picture itself. The painting wasn’t the
extension of a story at all, it was something in its own right.

### Variations

With a preset specified:
{% picture gallery portrait.jpg --alt An unsual picture --picture data-downloadable="true" %}

With an alternate source images:
{% picture half portrait.jpg tablet: dream-midrange.jpg desktop: dream-fullpage.jpg --alt An unsual picture --picture data-downloadable="true" %}
