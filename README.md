Customisable box with embossed lid
==================================

This is an [OpenSCAD] file for printing a box with a sliding lid with an embossed image.

It is inspired by Aisjam's [Parametric Box with Sliding Lid][tiv468917], but rewritten from scratch and with the addition of an image embossed into the lid.

Building
--------

First, you need to provide an image to emboss into the lid.  The image needs to be square, and called either `img.svg`, `img.eps` or `img.dxf`, depending on the file format.

### Building with Docker

If you have [Docker] available, you can build using Docker to avoid the need to install any other dependencies.  Simply run:

    make USE_DOCKER=Yes

### Building without Docker

Without [Docker], you will need [OpenSCAD] installed, plus any software for converting the image:

*   If your image is in DXF format, you need no additional software.
*   If your image is in EPS format, you need [Inkscape].
*   If your image is in SVG format, you need both [Inkscape] and [pstoedit].

Once you have these dependencies installed, you can build the STL file simply by running:

    make

[OpenSCAD]: http://www.openscad.org/
[tiv468917]: https://www.thingiverse.com/thing:468917
[Docker]: https://www.docker.com/
[Inkscape]: https://inkscape.org/
[pstoedit]: http://www.calvina.de/pstoedit/
