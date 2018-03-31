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

## Graphics State Operators

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| q |  | Save the current graphics state on the graphics state stack | 8.4.2 |
| Q |  | Restore the graphics state by from stack | 8.4.2 |
| cm | a,b,c,d,e,f | Concatenate to current transformation matrix (CTM) | 8.3.2 |
| w | w | Set the line width | 8.4.3.2 |
| J | s | Set the line cap style | 8.4.3.3 |
| j | s | Set the line join style | 8.4.3.4 |
| M | l | Set the miter limit | 8.4.3.5 |
| d | a,p | Set the line dash pattern |  8.4.3.6 |

Common transformation matrices are as follows:

- Translations are `[1 0 0 1 tx ty]`
- Scalings are `[sx 0 0 sy 0 0]`
- Rotations are `[cos(q) sin(q) -sin(q) cos(q) 0 0]`, where `q` is an angle counter clockwise.
- Skews are `[1 tan(a) tan(b) 1 0 0]`, which skews by angles `a` and `b` from the `x` and `y` axis.

## Color Operators

For RGB numbers, 0 is minimum intensity, 1 is maximum.

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| rg | r,g,b | Set RGB color for nonstroking operations | 8.6.8 |
| RG | r,g,b | Set RGB color for stroking operations | 8.6.8 |
| g |  | Set nonstroking gray level in DeviceGray colorspace | 8.6.8 |
| G |  | Set stroking gray level in DeviceGray colorspace | 8.6.8 |

## Path Construction Operators

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| m | x,y | Begin a new subpath | 8.6.8 |
| l | x,y | Begin a new subpath | 8.6.8 |
| h |  | Close path with a straight line | 8.6.8 |
| re | x,y,w,h | Add a rectangular path | 8.6.8 |

## Path Clipping Operators

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| W |  | Intersect current path with clipping region using nonzero winding rule | 8.5.4 |

## Path Painting Operators

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| f |  | Fill path using nonzero winding number rule | 8.5.3 |
| s |  | Stroke the path | 8.5.3 |
| B |  | Fill and stroke the path | 8.5.3 |

## Text Operators

| Operator | Operands | Description | Section |
|:--- |:--- |:--- |:--- |
| BT |  | Begin text | 9.4.1 |
| ET |  | End text | 9.4.1 |
| Tj | s | Display text | 9.4.3 |
| Tf | f,p | Select font resource `f` and point size `p` | 9.4.3 |
| Tm | a,b,c,d,e,f | Replace current text transformation matrix | 9.4.2 |
