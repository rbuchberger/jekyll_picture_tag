# Writing Output Formats

## Naming and Instantiating

In the relevant `_data/picture.yml` preset, `markup: example_format` will cause
the plugin to use an instance of `ExampleFormat` (with no arguments.)

You'll need to add an appropriate `require_relative` statement to
`../output_formats.rb`

## Input

When instantiated, your new class doesn't get any arguments. You can find
information by calling class methods on PictureTag. I'm no computer scientist,
so if this is a terrible way to do things I'd love to hear all about it. I did
it this way because information flow was getting arduous; I was passing a lot
of information to classes which only needed it to pass on to classes they
instantiate.

`PictureTag.source_images` returns an array of the source images provided in
the liquid tag. The first one is the base image, the rest that follow are
associated with media queries. Check out `source_image.rb` to see what they
offer.

There's a lot of information available, dig around in `../router.rb`.
Output formats should only consume this information, never modify it.

## Producing output

The instance of your new class should implement the `to_s` method, which
returns the desired markup. In the course of generating this markup, it should
also ensure that the necessary images are generated as well.

When you generate one of the srcsets prodvided under `../srcsets/`, it will
both provide an appropriate html attribute (only the part inside the quotes)
and generate the respective images.

## Basics module

`basics.rb` is a module which includes a few methods to do things common to
most/all output formats.
