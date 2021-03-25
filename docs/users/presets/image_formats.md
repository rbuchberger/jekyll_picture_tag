---
sort: 4
---

# Image Formats

_Format:_ `formats: [format1, format2, (...)]`

_Example:_ `formats: [webp, original]`

_Default_: `original`

Array (yml sequence) of the image formats you'd like to generate, in decreasing
order of preference. Browsers will render the first format they find and
understand, so **If you put jpg before webp, your webp images will never be
used**. `original` does what you'd expect. To supply webp, you must have an
imagemagick webp delegate installed. (Most package managers just name it 'webp')

_Supported formats are anything which imagemagick supports, and has an installed
delegate. See a list by running `$ convert --version`_.

