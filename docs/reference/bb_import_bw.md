# Import a Big Wig File

This is a thin wrapper around rtracklayer::import.bw. The purpose is to
serve as a helper function for making Trace objects from bigwig files.
This function converts the name of the numeric value metadata column to
"coverage" for consistency with Trace objects made from Seurat/Signac
objects. The numeric column it will look for is "score" by default. This
appears to be the default name applied by import.bw and so this is the
default value for this function. The option is provided to change it if
necessary. The group variable must be supplied. Typically this will be
something informative, like "ATAC" or some Histone mark that the data
come from.

## Usage

``` r
bb_import_bw(path, group, coverage_column = "score")
```

## Arguments

- path:

  file path to the bigwig file

- group:

  a label to apply that describes the source data for the track

- coverage_column:

  PARAM_DESCRIPTION, Default: 'score'

## Value

a granges object
