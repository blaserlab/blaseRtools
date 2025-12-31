# An S4 Class for Holding Image Metadata

This is an S4 Class for holding the relevant metadata we need for key
images. The idea is to generate this object for each of the images we
will use in a grant, paper or other important document. That way when we
want to reuse these images we know where they are.

One can construct a single image object using the Image() constructor
method. When called as such, it will open a file chooser to identify the
file from the network drive. Then it will provide an interactive menu to
add the needed metadata (see below).

The workflow is to use this to create a new Image object when you are
using a new key image in a grant or other document. Then you will add
the image to the image catalog using ImageCatalog.add.

The Image constructor provides several validation checks, including that
the image file must be accessible.

Each slot has it's own getter and setter methods which are identical to
the name of the slot.

**It is critical that your images are stored in a common network drive.
Ideally this is X/Labs/Blaser/staff/keyence imaging data**

**Avoid Duplication!! Please keep your all of your raw imaging data in
X/Labs/Blaser/staff and subdirectories.**

## Usage

``` r
# S4 method for class 'Image_'
show(object)

file_path(x)

file_path(x) <- value

species(x)

species(x) <- value

stage(x)

stage(x) <- value

genetics(x)

genetics(x) <- value

treatment(x)

treatment(x) <- value

microscope(x)

microscope(x) <- value

mag(x)

mag(x) <- value

filter(x)

filter(x) <- value

use(x)

use(x) <- value

note(x)

note(x) <- value
```

## Slots

- `file_path`:

  Path to file. Should start with ~/network/X/Labs/Blaser...

- `species`:

  The species being imaged.

- `stage`:

  The stage of the sample. Options include various times in hpf plus
  other for other timepoints.

- `genetics`:

  Any genetic modifications.

- `treatment`:

  Any treatments performed.

- `microscope`:

  The microscope used.

- `mag`:

  Magnification

- `filter`:

  The filter or camera setup used.

- `use`:

  The document the image is being used in.

- `note`:

  Any additional notes.
