# Run FIMO on Selected Ape Object Features

For the supplied Ape object, run FIMO to identify putative transcription
factor binding sites in a DNA subsequence.

## Usage

``` r
Ape.fimo(ape, fimo_feature, out = NULL)
```

## Arguments

- ape:

  An Ape instance

- fimo_feature:

  A character vector of features from the Ape object that will be used
  to run fimo.

- out:

  Directory that will be created to hold the fimo results. A date/time
  stamp will be appended. If null, the objects will not be saved and the
  function will only return a GRanges object
