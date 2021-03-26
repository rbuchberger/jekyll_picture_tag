---
sort: 4
---

# Deployment

Deploying a site with JPT is surprisingly tricky. This is because we depend on system libraries
(libvips and its dependencies) to generate images, but build environments have huge variation in
what is actually present. Just because a site build works on your local machine, doesn't mean it
will work when you try to deploy using a build service.

Generally, anything which involves building locally and uploading the generated site somewhere, will
work. Anything which pulls down a git repository and builds it in some container somewhere needs
extra verification. Often some image formats will be supported, while others will not without
installing additional packages.

## Help Wanted

We could really use help improving this page's guidance. I've created
[this](https://github.com/rbuchberger/jekyll_picture_tag/issues/240) issue for feedback; I want to
hear how you're deploying with JPT. I want to hear what worked well for you, and what did not. If
you're extra motivated and cool, you could make a pull request adding that information to this page.

## Netlify

As of March 26, 2021, with version 2.0.0, Netlify is mostly broken. It only supports jpg. I want to
support netlify as much as reasonably possible, so if a solution isn't found I'll re-add imagemagick
as an alternate backend and offer it as a configurable setting. Until then, stick with version 1.14.

## AWS S3

This method has a somewhat difficult setup, but once configured it works _very_ well. Since you
build the site locally, if your development build works then your production build will work.

[This](https://aws.amazon.com/premiumsupport/knowledge-center/cloudfront-serve-static-website/) is
the guide you want; **specifically the second option** (Using a website endpoint as the origin, with
anonymous (public) access allowed). This allows you to have https and excellent performance.

For deployment, you'll want to put together either some rake tasks or shell commands to do the
following:

* build: `JEKYLL_ENV=production bundle exec jekyll build`
* push: `aws s3 sync _site s3://(your bucket here)`
* invalidate: `aws cloudfront create-invalidation --distribution-id (your distribution id here) --paths '/*'`
  * Cloudfront caches assets for 24 hours. This command invalidates that cache, so your changes go
    live immediately.
* deploy: `build && push && invalidate`

(All of these depend on having the aws cli installed, with proper credentials configured.)
