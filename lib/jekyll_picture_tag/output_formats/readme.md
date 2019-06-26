# Writing Output Formats


## Naming and Instantiating

Names from the configuration wiAn output format is instantiated will be
converted from snake case to title case (I'm not sure what it's called.) And
instantiated. 

Example:

In `_data/picture.yml`: `markup: example_format` will cause the plugin to use
an instance of `ExampleFormat` (with no arguments.)

You'll need to add an appropriate `require_relative` statement to
`../output_formats.rb`

## Input

When instantiated, your new class doesn't get any arguments. You can find
information by calling class methods on PictureTag. I'm no computer scientist,
so if this is a terrible way to do things I'd love to hear all about it. I did
it this way because information flow was getting arduous; I was passing a lot
of information to classes which only needed it to pass on to classes they
instantiate.

`PictureTag.source_images` returns a hash of the source images provided in the
liquid tag. This relies on 2 properties of ruby hashes: They maintain their
order, and `nil` is a perfectly good key. The first image (unqualified) is
stored under `PictureTag.source_images[nil]`, and the rest of the keys are
media queries named in `_data/picture.yml`.

There's a lot of information available, dig around in `../instructions.rb`. Output formats should only consume this information, never modify it.

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
