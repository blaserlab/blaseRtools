# Replace The Path to a Fragment File In a Signac Object

Often you will wish to package a Signac object or share the object to
someone who does not have access to the same directories as you. This is
a problem because one of the internal sub-objects, the Fragment object,
holds a file path to a directory containing an atac fragments file and
its .tbi intex. Often this file will only be accessbile to you. This
function allows you to replace the fragments file path that is held
internally within the Signac object. Just copy the files to a shared
location and provide that file location to the function.

For Signac objects with multiple internal Fragments objects, provide
vector of file paths.

For packaged fragments files, use system.file or fs::path_package to
access this, usually from extdata.

## Usage

``` r
bb_fragment_replacement(obj, new_paths)
```

## Arguments

- obj:

  A signac object.

- new_paths:

  A character vector of new file paths. You must have the same number of
  new file paths as Fragments sub-objects within the signac object.

## Value

A modified Signac object.

## See also

`c("Cells.Fragment", "CountFragments", "CreateFragmentObject", "FilterCells", "Fragment-class", "Fragments", "Fragments", "SplitFragments", "UpdatePath", "ValidateCells", "ValidateFragments", "ValidateHash", "head.Fragment", "subset.Fragment")`,
[`CreateFragmentObject`](https://stuartlab.org/signac/reference/CreateFragmentObject.html)
[`cli_abort`](https://cli.r-lib.org/reference/cli_abort.html)
[`file_access`](https://fs.r-lib.org/reference/file_access.html)
[`map2`](https://purrr.tidyverse.org/reference/map2.html)
