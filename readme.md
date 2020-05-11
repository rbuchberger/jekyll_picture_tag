# Jekyll Picture Tag

**Responsive Images done correctly.**

It's simple to throw a photo on a page and call it a day, but doing justice to users on all
different browsers and devices is tedious and tricky. Tedious, tricky things should be automated.

Jekyll Picture Tag automatically builds cropped, resized, and reformatted images, builds several
kinds of markup, offers extensive configuration while requiring none, and solves both the art
direction and resolution switching problems with a little YAML configuration and a simple template
tag.

## Why use Responsive Images?

**Performance:** The fastest sites are static sites, but if you plonk a 2mb picture of your dog at
the top of a blog post you throw it all away. Responsive images allow you to keep your site fast,
without compromising image quality.

**Design:** Your desktop image may not work well on mobile, regardless of its resolution. We often
want to do more than just resize images for different screen sizes, we want to crop them or use a
different image entirely.

## Why use Jekyll Picture Tag?

**Developer Sanity:** If you want to serve multiple images in multiple formats and resolutions, you
have a litany of markup to write and a big pile of images to generate and organize. Jekyll Picture
Tag is your responsive images minion - give it simple instructions and it'll handle the rest. 

## Features

* Generate piles of cropped, resized, and converted image files.
* Generate corresponding markup in several different formats.
* Configure it easily, or not at all.
* Make Lighthouse happy.

## Documentation:

https://rbuchberger.github.io/jekyll_picture_tag/

## Changelog:

https://rbuchberger.github.io/jekyll_picture_tag/releases

Latest version: 

* 1.10.0 May 11, 2020
  * **Image Cropping support!** access the power of ImageMagick's `crop` function.
  * Don't issue a warning when `default` preset is not found.
  * Documentation improvements

## Help Wanted

Writing code is only part of the job; often the harder part is knowing what needs to be changed. Any
and all feedback is greatly appreciated, especially in regards to documentation. What are your pain
points? See the [contributing
guidelines](https://rbuchberger.github.io/jekyll_picture_tag/contributing), or the
[issues](https://github.com/rbuchberger/jekyll_picture_tag/issues) page for more.
