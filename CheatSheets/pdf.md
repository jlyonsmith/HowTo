# PDF File Format

These notes refer to [PDF Reference 1.7](https://github.com/jlyonsmith/HowTo/blob/master/CheatSheets/pdf_reference_1-7.pdf)

## Dumping a PDF as Text

First, `brew install qpdf`, then:

```
qpdf --qdf --object-streams=disable original.pdf uncompressed-original.pdf
```

## Coordinates

The default coordinate system has (0,0) in the lower left.  Rectangles are specified (llx, lly, urx, ury).

## Page

Pages objects have these box properties (page 145):

- `MediaBox` - size of the page, required
- `CropBox` - visible region, defaults to media box
- `BleedBox` - defaults to crop box
- `TrimBox` - defaults to crop box
- `ArtBox` - defaults to crop box

## Transparency

Transparency is achieved by adding a _graphics state_ with entries (page 222):

- `CA` - alpha for stroking operations
- `ca` - alpha for non-stroking operations

Then perform graphics operations with this new state.

## Form XObjects

Section 8.10, page 217.  PDF content stream with self contained sequence of graphics.  Can be inserted into the page resources and reused multiple times. Can have it's own resources which is useful for creating graphics contexts for transparency.
