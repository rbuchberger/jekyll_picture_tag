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

I have created a [testing repository](https://github.com/rbuchberger/jpt_tester) for this purpose.
It's just a barebones jekyll site with JPT, that tries to generate a bunch of image formats. Feel
free to use it for your own test builds.

```yaml
presets:
  default:
    formats: [avif, webp, jp2, png, gif, original]
```

## Help Wanted

We could really use help improving this page's guidance. I've created
[this](https://github.com/rbuchberger/jekyll_picture_tag/issues/240) issue for feedback; I want to
hear how you're deploying with JPT. I want to hear what worked well for you, and what did not. If
you're extra motivated and cool, you could make a pull request adding that information to this page.

## Netlify

Ensure you're using version 2.0.2 or later. No support for `jp2` or `avif` files. They have beta
homebrew support (by setting the build command to `brew install whatever && do_your_build`), but
attempting to install `libheif` this way runs over the time limit.

```
Libvips known savers: csv, mat, v, vips, ppm, pgm, pbm, pfm, hdr, png, jpg, jpeg, jpe, webp, tif,
tiff

Imagemagick known savers: bzlib, cairo, djvu, fftw, fontconfig, freetype, jbig, jng, jpeg, lcms,
lqr, ltdl, lzma, openexr, pangocairo, png, rsvg, tiff, wmf, x, xml, zlib
```

They run an old version of libvips, so cropping attention may not work the same way as it does
locally.

## AWS S3

This method has a somewhat difficult setup, but once configured it works _very_ well. Since you
build the site locally, if your development build works then your production build will work.

There is one caveat: other than the site root, links need to point to an html file. `/blog` won't
work, you need `/blog.html` or `/blog/index.html`. If you know a way to fix this, please speak up!

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

## AWS Amplify

[This](https://www.bsmth.de/blog/deploying-jekyll-github-actions-aws-amplify) article may be useful;
I haven't gotten it to work with a full set of image formats. The default build image doesn't
support jp2 and avif, but Amplify allows you to use a custom build image. If you take the time to
create one which can generate jpg, png, webp, jp2, and avif files, it would be marvelous of you to
share it.

## Github Pages

GitHub Pages only allows a very short whitelist of plugins, which sadly does not include JPT. You could run it locally, then commit and push the generated site to your Pages branch. 

Or use GitHub Actions to do this for you automatically. Here’s [an Actions workflow to build a JPT-enabled site and deploy it](https://gist.github.com/elstudio/38bacfe7aab63da082a418fd3a1ddb66). Commit that yaml file to the `.github/workflows` folder of your source repository, and Actions will build and deploy your site whenever you push changes to `main`.

See [How to use Jekyll Picture Tag or any Jekyll plugin with GitHub Pages](https://www.elstudio.us/code/use-any-jekyll-plugin-with-github-pages) for details of how it works.


## Cloudflare pages

They have the same restrictions as netlify: jpg, webp, and png work. jp2 and avif are no-go.
